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
    "maid": "+919650256625",
    "cook": "+919650256625",
    "driver": "+919650256625"
}

def fetch_contact(person_name: str)-> str:
    # TODO: fetch the person to call by the Google contacts if not present then call the api contact picker and let the user choose the number and person_name.
    return directory[person_name]

@agent.tool
async def call_someone(ctx: RunContext[CallAiDeps], person_name: str, message: str = "") -> str:
    """
    Call a household member and deliver a spoken message.
    Use this tool whenever the user wants to notify, inform, or instruct a household
    member, whether they explicitly name the person or the appropriate person can be
    inferred from their role and responsibilities.
    Args:
        ctx: the RunContext of the call
        person_name: The household member to call.
        message:The message to convey.
    """
    to_number= fetch_contact(person_name)
    try:
        sid = await asyncio.to_thread(
            make_call,
            message,
            client,
            to_number,
            From_Number,
            _settings.NGROK_BASE_URL,
        )
    except Exception as exc:
        return f"Call could not be initiated: {exc}"

    return f"Call initiated. Call SID: {sid}."
