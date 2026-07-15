from twilio.rest import Client
from agent.config.settings import get_settings

_settings = get_settings()

client = Client(_settings.TWILIO_ACCOUNT_SID, _settings.TWILIO_AUTH_TOKEN)
