from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env")

    ANTHROPIC_API_KEY: str
    AGENT_MODEL: str
    TWILIO_ACCOUNT_SID: str
    TWILIO_AUTH_TOKEN: str

@lru_cache()
def get_settings()->Settings:
    return Settings()
