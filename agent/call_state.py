from dataclasses import dataclass
from typing import Any


@dataclass
class CallConnection:
    connection: Any
    from_number: str
    to_number: str


ws_connections: dict[str, Any] = {}
call_sid_to_connection: dict[str, CallConnection] = {}


def register_ws_connection(connection_id: str, connection: Any) -> None:
    ws_connections[connection_id] = connection

def remove_ws_connection(connection_id: str) -> None:
    ws_connections.pop(connection_id, None)

def get_ws_connection(connection_id: str) -> Any | None:
    return ws_connections.get(connection_id)

def register_call(
    call_sid: str,
    connection: Any,
    from_number: str,
    to_number: str,
) -> None:
    call_sid_to_connection[call_sid] = CallConnection(
        connection=connection,
        from_number=from_number,
        to_number=to_number,
    )

def get_call_connection(call_sid: str) -> CallConnection | None:
    return call_sid_to_connection.get(call_sid)
