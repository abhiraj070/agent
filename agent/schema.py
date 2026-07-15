from pydantic import BaseModel, ConfigDict

class UserReference(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str


class ChatRequest(BaseModel):
    connection_id: str
    message: str

class AddMemberRequest(BaseModel):
    phone_number: str
    role: str
    preferred_language: str
    nick_name: str


class ChatResponse(BaseModel):
    response: str

class WsMessageRequest(BaseModel):
    message: str
    to_phone_number: str
    from_phone_number: str
