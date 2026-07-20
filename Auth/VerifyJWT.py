import datetime
from typing import Any

from fastapi import Depends, HTTPException, Request, Response, status
from fastapi.security import OAuth2PasswordBearer
from jose import ExpiredSignatureError, JWTError, jwt
from sqlalchemy.orm import Session

from agent.config.settings import get_settings
from agent.db.connect import get_db
from agent.db.model.user import User

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="start")
ALGORITHM = "HS256"


def credentials_exception(detail: str = "Could not validate credentials") -> HTTPException:
    return HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail=detail,
        headers={"WWW-Authenticate": "Bearer"},
    )


def decode_token(token: str) -> dict[str, Any]:
    settings = get_settings()
    return jwt.decode(token, settings.SECRET_KEY, algorithms=[ALGORITHM])


def get_user_id(payload: dict[str, Any]) -> int:
    user_id = payload.get("user_id")
    if user_id is None:
        raise credentials_exception()
    try:
        return int(user_id)
    except (TypeError, ValueError) as exc:
        raise credentials_exception() from exc


def get_user(payload: dict[str, Any], db: Session, expected_token_type: str) -> User:
    token_type = payload.get("token_type")
    if token_type != expected_token_type:
        raise credentials_exception()

    user_id = get_user_id(payload)
    user = db.get(User, user_id)
    if user is None:
        raise credentials_exception("User no longer exists")
    return user


def create_access_token(user_id: str) -> str:
    settings = get_settings()
    expires_at = datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(
        minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
    )
    payload = {"user_id": user_id, "token_type": "access", "exp": expires_at}
    return jwt.encode(payload, settings.SECRET_KEY, algorithm=ALGORITHM)


def get_refresh_token(request: Request) -> str | None:
    return (
        request.headers.get("X-Refresh-Token")
        or request.headers.get("refresh-token")
        or request.headers.get("refresh_token")
        or request.cookies.get("refresh_token")
    )


def get_current_user(
    request: Request,
    response: Response,
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> int:
    try:
        payload = decode_token(token)
        user = get_user(payload, db, expected_token_type="access")
        return user.id
    except ExpiredSignatureError:
        refresh_token = get_refresh_token(request)
        if refresh_token is None:
            raise credentials_exception("Access token expired")

        try:
            refresh_payload = decode_token(refresh_token)
        except ExpiredSignatureError as exc:
            raise credentials_exception("Refresh token expired") from exc
        except JWTError as exc:
            raise credentials_exception() from exc

        user = get_user(refresh_payload, db, expected_token_type="refresh")
        access_token = create_access_token(str(user.id))
        response.headers["X-Access-Token"] = access_token
        response.headers["Authorization"] = f"Bearer {access_token}"
        return user.id
    except JWTError as exc:
        raise credentials_exception() from exc
