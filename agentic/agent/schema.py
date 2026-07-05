from pydantic import BaseModel

def chatRequest(BaseModel):
    message: str

def chatResponse(BaseModel):
    response: str