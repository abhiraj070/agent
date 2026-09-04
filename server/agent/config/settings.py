from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env")

    AGENT_MODEL: str
    TWILIO_ACCOUNT_SID: str
    TWILIO_AUTH_TOKEN: str
    NGROK_BASE_URL: str
    DATABASE_URL: str
    ELEVEN_LABS_API_KEY: str
    VOICE_ID: str
    SECRET_KEY: str
    REFRESH_TOKEN_EXPIRE_DAYS: int
    ACCESS_TOKEN_EXPIRE_MINUTES: int
    TWILIO_SERVICE_SID: str
    OPENAI_API_KEY: str

@lru_cache()
def get_settings()->Settings:
    return Settings()
