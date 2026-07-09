from main import app
from fastapi import BackgroundTasks, Form
from fastapi.responses import Response
import httpx
from pathlib import Path
from agent.config.settings import get_settings
from utils.download_audio import download_audio
_settings = get_settings()

RECORDINGS_DIR = Path("recordings")

@app.post("/process_recording")
async def process_recording(
        background_tasks: BackgroundTasks,
        recording_url: str = Form(..., alias="RecordingUrl"),
        recording_sid: str = Form(..., alias="RecordingSid"),
        recording_status: str = Form(..., alias="RecordingStatus"),
):
    if recording_status != "completed":
        print(f"recording not ready: {recording_sid} status={recording_status}")
        return {"status": "ignored", "recording_status": recording_status}

    print("getting the recording")
    url = recording_url + ".wav"
    async with httpx.AsyncClient(
            auth=(_settings.TWILIO_ACCOUNT_SID, _settings.TWILIO_AUTH_TOKEN)
    ) as client:
        response = await client.get(url)
        response.raise_for_status()
        audio = response.content
    print("got the recording")
    RECORDINGS_DIR.mkdir(exist_ok=True)
    filename = RECORDINGS_DIR / f"{recording_sid}.wav"
    with open(filename, "wb") as f:
        f.write(audio)
    print("done")
    background_tasks.add_task(download_audio, recording_sid, )
    return Response("<Response><Say>Thank you. I will share you response to the sender</Say></Response>", media_type="application/xml")
    # TODO: can replace sender-> the name of the sender.

@app.post("/recording_finished")
async def recording_finished():
    return Response("<Response><Say>Thank you.</Say><Hangup /></Response>", media_type="application/xml")
