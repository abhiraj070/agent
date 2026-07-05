from pydantic import BaseModel

class chatRequest(BaseModel):
    message: str

class chatResponse(BaseModel):
    response: str