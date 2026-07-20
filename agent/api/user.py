from main import app
from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import select
from agent.db.connect import get_db
from agent.db.model.user import User, Activity
from Auth.VerifyJWT import get_current_user
from agent.schema import MemberResponse
from typing import Annotated
from agent.schema import ActivityResponse, DeleteActivityRequest

@app.patch("/add-language")
def add_language(userId: int= Depends(get_current_user), language: str = "en", db: Session = Depends(get_db)):
    user= db.get(User, int(userId))
    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    user.preferred_language = language
    db.commit()
    db.refresh(user)

@app.get("/get-my-members", response_model=list[MemberResponse]) #this describs thow the response will look like
def get_my_members(db: Session= Depends(get_db),userId: int= Depends(get_current_user)):
    user=db.get(User, int(userId))
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    members= user.members
    return members

@app.get("/get-my-activity",response_model=list[ActivityResponse])
def get_activity(userId: Annotated[int, Depends(get_current_user)], db: Session= Depends(get_db)):
    activities= db.scalars(select(Activity).where(Activity.user_id==int(userId))).all()
    if not activities:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail= "No activity found") 
    return activities

@app.post("/delete-my-activity")
def delete_activity(request: DeleteActivityRequest, userid: Annotated[int, Depends(get_current_user)], db: Session= Depends(get_db)):
    activity= db.get(Activity, int(request.id))
    if not activity:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail= "Activity not found")
    isOwner= activity.user_id==userid
    if not isOwner:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="You cannot access this activity")
    db.delete(activity)
    db.commit()