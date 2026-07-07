from twilio.rest.video.v1.room import recording_rules

from main import app
from fastapi import Form
import httpx
from agent.config.settings import get_settings
_settings = get_settings()
@app.get("/process_recording")
async def process_recording(
        recording_url: str= Form(...),
        recording_sid: str= Form(...),
):
    url = recording_url + ".wav"
    async with httpx.AsyncClient(
            auth=(_settings.ACCOUNT_SID, _settings.AUTH_TOKEN)
    ) as client:
        response = await client.get(url)
        audio = response.content
    filename = f"recordings/{recording_sid}.wav"
    with open(filename, "wb") as f:
        f.write(audio)

