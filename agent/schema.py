from pydantic import BaseModel, ConfigDict

class UserReference(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str


class ChatRequest(BaseModel):
    #user: UserReference
    message: str


class ChatResponse(BaseModel):
    response: str
