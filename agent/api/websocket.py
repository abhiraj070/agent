import uuid

from main import app
from fastapi import WebSocket, WebSocketDisconnect
from utils.make_call import make_call
from agent.schema import WsMessageRequest

ws_connections: dict= {}

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    try:
        await websocket.accept()
        connection_id = str(uuid.uuid4())
        ws_connections[connection_id] = websocket
        await websocket.send_json({"connection_id": connection_id, "connection": websocket})
        while True:
            data= await websocket.receive()
            validated_data= WsMessageRequest.model_validate(data)
            make_call(validated_data.message, validated_data.to_phone_number, validated_data.from_phone_number)i
    except WebSocketDisconnect as e:
        raise e
    except Exception as e:
        raise e


