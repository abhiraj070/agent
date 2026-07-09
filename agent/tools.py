from pydantic_ai import RunContext

from agent.deps import CallAiDeps
from agent.orchestrator import agent
from twilio.rest import Client
from agent.config.settings import get_settings
from utils.make_call import make_call

_settings = get_settings()

client = Client(_settings.TWILIO_ACCOUNT_SID, _settings.TWILIO_AUTH_TOKEN)
From_Number= "+16592443594"

@agent.tool
def call_someone(ctx:RunContext[CallAiDeps], person_name: str, message: str = "") -> str:
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
    # TODO: fetch the person to call by the Google contacts if not present then call the api contact picker and let the user coose the number and person_name.
    to_number= "+919650256625"
    sid=-1
    try:
        sid= make_call(message, client, to_number, From_Number, _settings.PUBLIC_BASE_URL)
        print("making the call")
        # TODO:handle edge case for not picking up the call.
    except Exception as e:
        print(e)
    # TODO: create a separate table for call logs. from->to. update "to" everytime, if from is already present. store the numbers with their names.you can use call.sid for unique call. rec req will contain so search wil be easy
    return f"Call initiated. Call SID: {sid}. The recording will be saved after Twilio posts back to /process_recording."

