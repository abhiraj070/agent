from pydantic import BaseModel

from agent.db.model.user import User


class ChatRequest(BaseModel):
    user: User
    message: str

class ChatResponse(BaseModel):
    response: str