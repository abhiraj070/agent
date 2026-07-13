from main import app
from fastapi import BackgroundTasks, Form
from fastapi.responses import Response
from utils.download_audio import download_and_transcribe

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

    # A recording-status webhook does not need TwiML.  Acknowledge it before
    # downloading or transcribing so Twilio can release the call immediately.
    background_tasks.add_task(download_and_transcribe, recording_url + ".wav", recording_sid)
    return Response(status_code=204)

@app.post("/recording_finished")
async def recording_finished():
    # This endpoint is reached after the recording is submitted.  Do not add a
    # farewell prompt: it keeps the outbound leg open unnecessarily.
    return Response("<Response><Hangup /></Response>", media_type="application/xml")
