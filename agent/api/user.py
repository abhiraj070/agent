from main import app
from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session
from agent.db.connect import get_db
from agent.db.model.user import User
from Auth.VerifyJWT import get_current_user
from agent.schema import MemberResponse

@app.patch("/add-language")
def add_language(userId: int= Depends(get_current_user), language: str = "en", db: Session = Depends(get_db)):
    user= db.get(User, int(userId))
    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    user.preferred_language = language
    db.commit()
    db.refresh(user)

@app.get("/get-my-members", response_model=list[MemberResponse]) #this describs thow the response will look like
def getmymembers(db: Session= Depends(get_db),userId: int= Depends(get_current_user)):
    user=db.get(User, int(userId))
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    members= user.members
    return members
