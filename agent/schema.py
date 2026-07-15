from pydantic import BaseModel, ConfigDict, Field


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
    want_callback: bool
    delay_minutes: int = Field(default=0, ge=0)
