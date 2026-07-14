import datetime

from main import app
from fastapi import Depends, Form
from agent.db.model.user import User
from agent.db.connect import get_db
from jose import jwt
from agent.config.settings import get_settings
from sqlalchemy import select
from sqlalchemy.orm import Session

_settings = get_settings()
Algorithm= "HS256"
@app.post("/start")
def start(
    phone_number: str = Form(...),
    db: Session = Depends(get_db),
):
    user = db.scalar(select(User).where(User.phone_number == phone_number))
    if user is None:
        user = User(phone_number=phone_number)
        db.add(user)
        db.commit()
        db.refresh(user)

    now = datetime.datetime.now(datetime.timezone.utc)
    accessTokenPayload = {
        "user_id": str(user.id),
        "token_type": "access",
        "exp": now + datetime.timedelta(minutes=_settings.ACCESS_TOKEN_EXPIRE_MINUTES),
    }
    refreshTokenPayload = {
        "user_id": str(user.id),
        "token_type": "refresh",
        "exp": now + datetime.timedelta(days=_settings.REFRESH_TOKEN_EXPIRE_DAYS),
    }

    access_token= jwt.encode(accessTokenPayload,_settings.SECRET_KEY, algorithm=Algorithm)
    refresh_token= jwt.encode(refreshTokenPayload, _settings.SECRET_KEY, algorithm=Algorithm)
    return {"access_token": access_token, "refresh_token": refresh_token}
