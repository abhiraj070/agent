from functools import lru_cache
from pathlib import Path

import httpx
from fastapi import UploadFile

from server.agent.call_state import get_call_connection
from server.agent.config.settings import get_settings


RECORDINGS_DIR = Path("recordings")


@lru_cache(maxsize=1)
def get_transcription_model():
    _settings = get_settings()
    #from faster_whisper import WhisperModel
    #return WhisperModel("base", device="cpu", compute_type="int8")
    from openai import AsyncOpenAI
    client = AsyncOpenAI(api_key=_settings.OPENAI_API_KEY)
    return client


async def download_and_transcribe(recording_url: str, recording_sid: str, call_sid: str) -> str:
    settings = get_settings()
    async with httpx.AsyncClient(timeout=30.0) as client:
        response = await client.get(
            recording_url,
            auth=(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN),
        )
    response.raise_for_status()

    RECORDINGS_DIR.mkdir(exist_ok=True)
    recording_file = RECORDINGS_DIR / f"{recording_sid}.wav"
    recording_file.write_bytes(response.content)
    return await transcribe_recording(recording_sid, call_sid)


async def transcribe_recording(recording_sid: str, call_sid: str) -> str:

    if recording_sid.startswith("CA"):
        raise ValueError(f"Expected a recording SID, but got a call SID: {recording_sid}")

    recording_file = RECORDINGS_DIR / f"{recording_sid}.wav"
    if not recording_file.exists():
        raise FileNotFoundError(f"Recording file does not exist yet: {recording_file}")
    try:
        #model = get_transcription_model()
        #segments, _ = model.transcribe(str(recording_file), beam_size=5, vad_filter=True)
        #text = " ".join(segment.text.strip() for segment in segments).strip()
        client= get_transcription_model()
        with recording_file.open("rb") as audio_file:
            transcript = await client.audio.transcriptions.create(
                model="whisper-1",
                file=audio_file,
            )
        text= transcript.text
        call_context = get_call_connection(call_sid)
        connection = call_context.connection if call_context else None
        if connection:
            await connection.send_json({"message": text, "status": "completed"})
        return text
    finally:
        if recording_file.exists():
            recording_file.unlink()
download_audio = transcribe_recording

async def transcribe_audio_file(audio: UploadFile) -> str:
    client = get_transcription_model()
    audio_bytes = await audio.read()
    transcript = await client.audio.transcriptions.create(
        model="whisper-1",
        file=(audio.filename or "recording.m4a", audio_bytes),
    )
    return transcript.text
