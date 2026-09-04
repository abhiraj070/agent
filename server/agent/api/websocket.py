import asyncio
import uuid

from main import app
from fastapi import WebSocket, WebSocketDisconnect
from server.utils.make_call import make_call
from server.agent.schema import WsMessageRequest
from server.agent.call_state import register_call, register_ws_connection, remove_ws_connection


async def schedule_callback(validated_data: WsMessageRequest, websocket: WebSocket) -> None:
    if validated_data.delay_minutes:
        await asyncio.sleep(validated_data.delay_minutes * 60)

    sid = await asyncio.to_thread(
        make_call,
        validated_data.message,
        validated_data.to_phone_number,
        validated_data.from_phone_number,
    )
    register_call(
        sid,
        websocket,
        validated_data.from_phone_number,
        validated_data.to_phone_number,
    )
    await websocket.send_json({"status": "call initiated", "call_sid": sid})

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    connection_id = str(uuid.uuid4())
    try:
        await websocket.accept()
        register_ws_connection(connection_id, websocket)
        await websocket.send_json({"connection_id": connection_id})
        while True:
            data= await websocket.receive_json()
            validated_data= WsMessageRequest.model_validate(data)
            want_callback= validated_data.want_callback
            if want_callback:
                asyncio.create_task(schedule_callback(validated_data, websocket))
                await websocket.send_json({"status": "scheduled"})
    except WebSocketDisconnect :
        remove_ws_connection(connection_id)
    except Exception as e:
        raise e

