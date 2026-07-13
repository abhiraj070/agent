from functools import lru_cache
from pathlib import Path

import httpx

from agent.config.settings import get_settings


RECORDINGS_DIR = Path("recordings")


@lru_cache(maxsize=1)
def get_transcription_model():
    """Load Whisper only when there is a completed recording to process."""
    from faster_whisper import WhisperModel

    return WhisperModel("base", device="cpu", compute_type="int8")


def download_and_transcribe(recording_url: str, recording_sid: str) -> str:
    """Fetch and transcribe a completed recording outside the webhook response."""
    settings = get_settings()
    response = httpx.get(
        recording_url,
        auth=(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN),
        timeout=30.0,
    )
    response.raise_for_status()

    RECORDINGS_DIR.mkdir(exist_ok=True)
    recording_file = RECORDINGS_DIR / f"{recording_sid}.wav"
    recording_file.write_bytes(response.content)
    return transcribe_recording(recording_sid)


def transcribe_recording(recording_sid: str) -> str:

    if recording_sid.startswith("CA"):
        raise ValueError(f"Expected a recording SID, but got a call SID: {recording_sid}")

    recording_file = RECORDINGS_DIR / f"{recording_sid}.wav"
    if not recording_file.exists():
        raise FileNotFoundError(f"Recording file does not exist yet: {recording_file}")

    model = get_transcription_model()
    segments, _ = model.transcribe(str(recording_file), beam_size=5, vad_filter=True)
    text = " ".join(segment.text.strip() for segment in segments).strip()
    # TODO: create a resold dict of from_user_number, name, to_user_number, name, message.
    # resul={query_user:}
    # TODO: send this test to WhatsApp/UI.
    print(text)
    return text


# Backwards-compatible name for callers that already saved the file locally.
download_audio = transcribe_recording
