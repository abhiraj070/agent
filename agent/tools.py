import asyncio

from pydantic_ai import RunContext

from agent.deps import CallAiDeps
from agent.orchestrator import agent
from twilio.rest import Client
from agent.config.settings import get_settings
from utils.make_call import make_call

_settings = get_settings()

client = Client(_settings.TWILIO_ACCOUNT_SID, _settings.TWILIO_AUTH_TOKEN)
From_Number= "+16592443594"

directory={
    "maid": "+918294240491",
    "cook":  "+919650256625",
    "driver": "+918809008666"
}

async def start_household_call(to_number: str, message: str) -> str:
    return await asyncio.to_thread(
        make_call,
        message,
        client,
        to_number,
        From_Number,
        _settings.NGROK_BASE_URL,
    )

@agent.tool
async def call_someone(ctx: RunContext[CallAiDeps], phone_number: str, message: str = "") -> str:
    """
    Call one household member and deliver that person's spoken message.
    Use this tool once for every household member the user asks to notify, inform,
    or instruct. For a multi-person request, make separate calls with each person's
    own instructions; do not combine their messages into one call.
    Args:
        phone_number: The household number to call.
        message: The message to convey.
    """
    try:
        sid = await start_household_call(phone_number, message)
    except Exception as exc:
        return f"Call could not be initiated: {exc}"

    return f"Call initiated. Call SID: {sid}."
