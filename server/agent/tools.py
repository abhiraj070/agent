import asyncio

from pydantic_ai import RunContext

from server.agent.deps import CallAiDeps
from server.agent.orchestrator import agent
from server.utils.make_call import make_call
from server.agent.call_state import get_ws_connection, register_call

async def start_household_call(to_number: str, from_number: str, message: str, connection_id: str) -> str:
    sid= await asyncio.to_thread(
        make_call,
        message,
        to_number,
        from_number,
    )
    connection = get_ws_connection(connection_id)
    if connection is None:
        raise ValueError("WebSocket connection is no longer active.")
    register_call(sid, connection, from_number, to_number)
    return sid

@agent.tool
async def call_someone(ctx: RunContext[CallAiDeps], to_phone_number: str, message: str = "") -> str:
    """
    Call one household member and deliver that person's spoken message.
    Use this tool once for every household member the user asks to notify, inform,
    or instruct. For a multi-person request, make separate calls with each person's
    own instructions; do not combine their messages into one call.
    Args:
        to_phone_number: The household number to call.
        message: The message to convey.
    """
    from_phone_number = ctx.deps.from_phone_number
    connection_id = ctx.deps.connection_id
    try:
        sid = await start_household_call(to_phone_number, from_phone_number, message, connection_id)
    except Exception as exc:
        return f"Call could not be initiated: {exc}"

    return f"Call initiated. Call SID: {sid}."
