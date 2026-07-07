from pydantic_ai import RunContext

from agent.deps import Home_ai_deps
from agent.orchestrator import agent
from twilio.rest import Client
from agent.config.settings import get_settings
from utils.make_call import make_call
from utils.download_audio import download_audio

_settings = get_settings()

client = Client(_settings.TWILIO_ACCOUNT_SID, _settings.TWILIO_AUTH_TOKEN)
From_Number= "+16592443594"

@agent.tool
def call_cook(message: str = "") -> str:
    """
    Calls the household cook and deliver a spoken message.

    Use this tool when:
    - user explicitly asks to call or inform the cook.
    - user wants to send cooking- or meal-related instructions.
    - user wants to request preparation of food or beverages.

    Do NOT use this tool when:
    - request is unrelated to cooking or meals.
    - No message needs to be communicated to the cook.

    Args:
        message:
            exact message that should be conveyed to the cook.

    Returns:
        Confirmation or response from the call.
    """

    #call logic
    response= " "
    return response

@agent.tool
def call_maid(message: str = "") -> str:
    """
    Call the household maid and deliver a spoken message.

    Use this tool when:
    - The user explicitly asks to call or inform the maid.
    - The user wants to send a message directly to the maid.

    Do NOT use this tool when:
    - The task should instead be handled by another household member (for example, the cook, driver, or Amrita).
    - No message needs to be communicated.

    Args:
        message:
            The exact message that should be conveyed to the maid.

    Returns:
        Confirmation or response from the call.
    """
    #call logic
    to_number= "+919650256625"
    sid= make_call(message, client, to_number, From_Number)
    response= download_audio(sid)
    return response

@agent.tool
def call_driver(message: str = "") -> str:
    """
    Call the household driver and deliver a spoken message.

    Use this tool when:
    - The user explicitly asks to call or inform the driver.
    - The user is planning to travel and the driver should be informed.
    - Transportation or pickup arrangements need to be communicated.

    If the user only asks to be taken somewhere without specifying a message,
    generate an appropriate message such as:
    "Please be ready. We will be leaving shortly."

    Do NOT use this tool when:
    - The request is unrelated to transportation.
    - No communication with the driver is required.

    Args:
        message:
            The message that should be conveyed to the driver.

    Returns:
        Confirmation or response from the call.
    """
    #call logic
    response= " "
    return response

@agent.tool
def call_amrita(message: str = "") -> str:
    """
    Call Amrita and deliver a spoken message.

    Amrita is the primary household caretaker and can handle general house-related tasks.

    Use this tool when:
    - The user explicitly asks to call or inform Amrita.
    - The user requests household preparation before arrival.
    - The user requests cleaning or organizing.
    - The user requests switching on appliances (for example, ACs or lights).
    - The user requests care for Coco, such as feeding or taking Coco for a walk.
    - The request involves general household assistance.

    Prefer this tool over the maid whenever the request is about managing the home
    rather than sending a message specifically to the maid.

    Do NOT use this tool when:
    - The request is specifically about cooking (use the cook).
    - The request is specifically about transportation (use the driver).
    - No communication is required.

    Args:
        message:
            The message that should be conveyed to Amrita.

    Returns:
        Confirmation or response from the call.
    """
    #call logic
    response= " "
    return response
