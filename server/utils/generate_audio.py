import os
import uuid

from elevenlabs.client import ElevenLabs
from server.agent.config.settings import get_settings

_settings = get_settings()
client= ElevenLabs(api_key=_settings.ELEVEN_LABS_API_KEY)

def generate_audio(text: str)-> str:
    """
    Generates an MP3 and returns the filename.
    """
    filename = f"{uuid.uuid4()}.mp3"
    filepath= os.path.join("audio", filename)
    audio= client.text_to_speech.convert(
        voice_id=_settings.VOICE_ID,
        model_id="eleven_flash_v2_5",
        text=text,
        output_format="mp3_44100_128"
    )
    with open(filepath, "wb") as f:
        for chunk in audio:
            f.write(chunk)

    return filename
