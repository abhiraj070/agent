from fastapi import Depends, HTTPException, status, UploadFile, File, Form
from Auth.VerifyJWT import get_current_user
from agent.schema import ChatRequest, ChatResponse
from main import app
from agent.db.connect import get_db
from agent.db.model.user import User, Activity
from typing import Annotated
from sqlalchemy.orm import Session
from agent.run_agent import run_agent
from utils.download_audio import transcribe_audio_file

@app.post("/recieve-message", response_model=ChatResponse)
async def chat(
        request: ChatRequest,
        user_id: Annotated[int, Depends(get_current_user)],
        db: Session = Depends(get_db),
):
    message = request.message
    connection_id = request.connection_id
    user = db.get(User, int(user_id))
    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    members = user.members
    if not members:
        return ChatResponse(response="No household members have been added yet.")

    phone_number = user.phone_number

    try:
        result = await run_agent(members, phone_number, connection_id, message)
        activity= Activity(message= message, response= result.output, user_id= user_id)
        db.add(activity)
        db.commit()
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Couldn't complete that request. Try again.",
        ) from exc

    return ChatResponse(response=result.output)

@app.post("/receive-audio-file", response_model=ChatResponse)
async def receive_audio_file(
        connection_id: Annotated[str, Form()],
        userId: Annotated[int, Depends(get_current_user)],
        audio: UploadFile = File(...),
        db: Session = Depends(get_db),
):
    user= db.get(User, int(userId))
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    members= user.members
    if not members:
        return ChatResponse(response="no household member has been added yet")
    phone_number= user.phone_number

    try:
        message = await transcribe_audio_file(audio)
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Couldn't transcribe that recording. Try again.",
        ) from exc

    try:
        result = await run_agent(members, phone_number, connection_id, message)
        activity= Activity(message= message, response= result.output, user_id= userId)
        db.add(activity)
        db.commit()
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Couldn't complete that request. Try again.",
        ) from exc

    return ChatResponse(response=result.output)