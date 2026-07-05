from functools import lru_cache

from pydantic_settings import settings, BaseSettings

class Settings(BaseSettings):
    ANTHROPIC_API_KEY: str
    AGENT_MODEL: str

@lru_cache()
def get_settings()->Settings:
    return Settings()