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

def fetch_contact(person_name: str)-> str:
    # TODO: fetch the person to call by the Google contacts if not present then call the api contact picker and let the user choose the number and person_name.
    return directory[person_name]

async def start_household_call(person_name: str, message: str) -> str:
    to_number= fetch_contact(person_name)
    return await asyncio.to_thread(
        make_call,
        message,
        client,
        to_number,
        From_Number,
        _settings.NGROK_BASE_URL,
    )

@agent.tool
async def call_someone(ctx: RunContext[CallAiDeps], person_name: str, message: str = "") -> str:
    """
    Call one household member and deliver that person's spoken message.
    Use this tool once for every household member the user asks to notify, inform,
    or instruct. For a multi-person request, make separate calls with each person's
    own instructions; do not combine their messages into one call.
    Args:
        person_name: The household member to call.
        message: The message to convey.
    """
    try:
        sid = await start_household_call(person_name, message)
    except Exception as exc:
        return f"Call could not be initiated: {exc}"

    return f"Call initiated. Call SID: {sid}."
