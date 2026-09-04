import datetime

from twilio.base.exceptions import TwilioRestException
from main import app
from fastapi import Depends, Form, HTTPException
from server.agent.db.model.user import User
from server.agent.db.connect import get_db
from jose import jwt
from server.agent.config.settings import get_settings
from sqlalchemy import select
from sqlalchemy.orm import Session
from twilio.rest import Client

_settings = get_settings()
Algorithm= "HS256"
client= Client(_settings.TWILIO_ACCOUNT_SID, _settings.TWILIO_AUTH_TOKEN)

@app.post("/send-otp")
def send_otp(phone_number: str):
    try:
        client.verify.v2.services(_settings.TWILIO_SERVICE_SID).verifications.create(to=phone_number, channel="sms")
        return {"message": "OTP sent successfully"}
    except TwilioRestException as e:
        raise HTTPException(status_code=400, detail=e.msg)

@app.post("/verify-otp")
def verify_otp(
    phone_number: str = Form(...),
    otp_code: str = Form(...),
    db: Session = Depends(get_db),
):
    try:
        verification = client.verify.v2.services(
            _settings.TWILIO_SERVICE_SID
        ).verification_checks.create(
            to=phone_number,
            code=otp_code
        )
        if verification.status != "approved":
            raise HTTPException(
                status_code=400,
                detail="Invalid or expired OTP"
            )
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

        access_token = jwt.encode(accessTokenPayload, _settings.SECRET_KEY, algorithm=Algorithm)
        refresh_token = jwt.encode(refreshTokenPayload, _settings.SECRET_KEY, algorithm=Algorithm)
        return {"access_token": access_token, "refresh_token": refresh_token}

    except TwilioRestException as e:
        raise HTTPException(
            status_code=400,
            detail=e.msg
        )

