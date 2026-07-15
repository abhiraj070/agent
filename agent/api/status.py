from main import app
from fastapi import Form
from fastapi.responses import Response
from agent.call_state import get_call_connection


@app.post("/call-status")
async def call_status(CallStatus: str = Form(...),
    CallSid: str = Form(...,alias="CallSid")
,):
    call_context = get_call_connection(CallSid)
    if call_context and call_context.connection:
        await call_context.connection.send_json(
            {
                "status": CallStatus.replace("-", " "),
                "to_phone_number": call_context.to_number,
                "from_number": call_context.from_number,
            }
        )
    return Response(status_code=204)
