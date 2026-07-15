from main import app
from fastapi import Form
from agent.tools import callSid_to_connection
@app.post("/call-status")
async def call_status(CallStatus: str = Form(...),
    CallSid: str = Form(...,alias="CallSid")
,):
    match CallStatus:
        case "busy":
            connection = callSid_to_connection[CallSid].connection
            to_number = callSid_to_connection[CallSid].to_number
            from_number = callSid_to_connection[CallSid].from_number
            if connection:
                await connection.send_json({"status": "busy", "to_phone_number": to_number, "from_number": from_number})
        case "no-answer":
            connection = callSid_to_connection[CallSid].connection
            to_number = callSid_to_connection[CallSid].to_number
            from_number = callSid_to_connection[CallSid].from_number
            if connection:
                await connection.send_json({"status": "no answer", "to_phone_number": to_number, "from_number": from_number})
        case "failed":
            connection = callSid_to_connection[CallSid].connection
            to_number = callSid_to_connection[CallSid].to_number
            from_number = callSid_to_connection[CallSid].from_number
            if connection:
                await connection.send_json({"status": "failed", "to_phone_number": to_number, "from_number": from_number})
        case "canceled":
            connection = callSid_to_connection[CallSid].connection
            to_number = callSid_to_connection[CallSid].to_number
            from_number = callSid_to_connection[CallSid].from_number
            if connection:
                await connection.send_json({"status": "canceled", "to_phone_number": to_number, "from_number": from_number})
