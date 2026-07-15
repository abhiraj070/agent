import asyncio
import uuid

from main import app
from fastapi import WebSocket, WebSocketDisconnect
from utils.make_call import make_call
from agent.schema import WsMessageRequest

ws_connections: dict= {}

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    connection_id = str(uuid.uuid4())
    try:
        await websocket.accept()
        ws_connections[connection_id] = websocket
        await websocket.send_json({"connection_id": connection_id, "connection": websocket})
        while True:
            data= await websocket.receive()
            validated_data= WsMessageRequest.model_validate(data)
            want_callback= validated_data.want_callback
            delay_minutes= validated_data.delay_minutes
            if want_callback:
                await asyncio.sleep(delay_minutes*60)
                make_call(validated_data.message, validated_data.to_phone_number, validated_data.from_phone_number)
    except WebSocketDisconnect :
        ws_connections.pop(connection_id, None)
    except Exception as e:
        raise e


