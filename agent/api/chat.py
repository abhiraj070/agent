from fastapi import Depends, HTTPException, status
from Auth.VerifyJWT import get_current_user
from agent.deps import CallAiDeps
from agent.orchestrator import call_agent
from agent.schema import ChatRequest, ChatResponse
from main import app
from agent.db.connect import get_db
from agent.db.model.user import User
from typing import Annotated
from sqlalchemy.orm import Session

@app.post("/chat")
async def chat(
        request: ChatRequest,
        user_id: Annotated[str, Depends(get_current_user)],
        db: Session = Depends(get_db),
) -> ChatResponse:
    message = request.message
    connection_id = request.connection_id
    user = db.get(User, int(user_id))
    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    members = user.members
    if not members:
        return ChatResponse(response="No household members have been added yet.")

    phone_number = user.phone_number
    member_context = [
        (
            f"{member.nick_name}: "
            f"role={member.role.value.replace('_', ' ')}, "
            f"phone_number={member.phone_number}, "
            f"preferred_language={member.preferred_language}"
        )
        for member in members
    ]
    context = (
        "Route calls fast. Split the request by household member. "
        "Call call_someone once per requested member, then move on. "
        "Never repeat a member or combine instructions. "
        "Use the member's phone_number when calling. "
        "Use natural smooth human language in each member's preferred_language. "
        "Contacts: " + ", ".join(member_context)
    )
    deps = CallAiDeps(context=context, from_phone_number= str(phone_number), connection_id= connection_id)

    result = await call_agent.run(message, deps=deps)

    return ChatResponse(response=result.output)
