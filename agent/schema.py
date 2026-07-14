from pydantic import BaseModel, ConfigDict

class UserReference(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str


class ChatRequest(BaseModel):
    message: str

class AddMemberRequest(BaseModel):
    phone_number: str
    role: str
    preferred_language: str
    nick_name: str


class ChatResponse(BaseModel):
    response: str
