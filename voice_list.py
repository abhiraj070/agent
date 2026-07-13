from elevenlabs import ElevenLabs
from agent.config.settings import get_settings

_settings = get_settings()
client = ElevenLabs(api_key=_settings.ELEVEN_LABS_API_KEY)

voices = client.voices.get_all()

for v in voices.voices:
    print(v.name, v.voice_id)