from fastapi import Depends, HTTPException, status
from Auth.VerifyJWT import get_current_user
from main import app
from agent.db.model.user import Member, Role, User
from agent.db.connect import get_db
from agent.schema import AddMemberRequest
from typing import Annotated
from sqlalchemy import select
from sqlalchemy.orm import Session

ROLE_DESCRIPTIONS = {
    Role.Cook: """
        Responsible for all cooking and meal preparation.
        Primary responsibilities:
        - Preparing breakfast, lunch, dinner, snacks, tea, coffee, and other beverages.
        - Handling requests related to meals and food preparation.
    """,
    Role.Maid: """
        Responsible for routine household chores and cleanliness.
        Primary responsibilities:
        - Carrying out general cleaning and maintenance tasks.
        - Receiving household-related instructions from the user.
    """,
    Role.Driver: """
        Responsible for transportation and travel assistance.
        Primary responsibilities:
        - Driving the user or family members.
        - Pickup and drop-off arrangements.
    """,
    Role.House_Manager: """
        Primary household caretaker responsible for managing the home.
        Primary responsibilities:
        - Preparing the house before the user's arrival.
        - Switching household appliances on or off, such as ACs and lights.
    """,
    Role.Gardner: """
        Responsible for maintaining the garden and outdoor plants.
        Primary responsibilities:
        - Watering plants, trees, and lawns.
        - Trimming, pruning, and maintaining plants.
    """,
    Role.Nanny: """
        Responsible for childcare and the well-being of children.
        Primary responsibilities:
        - Supervising and caring for children.
        - Feeding, bathing, and dressing children.
    """,
    Role.Dog_Walker: """
        Responsible for caring for and exercising dogs.
        Primary responsibilities:
        - Walking dogs according to their schedule.
        - Cleaning up after the dog during walks.
    """,
    Role.Maintenance: """
        Responsible for home repairs and maintenance tasks.
        Primary responsibilities:
        - Repairing household fixtures and appliances.
        - Fixing plumbing, electrical, or carpentry issues when appropriate.
    """,
    Role.Security: """
        Responsible for ensuring the safety and security of the property.
        Primary responsibilities:
        - Patrolling the property and checking for security concerns.
        - Responding to suspicious activity or emergencies.
        - Reporting security incidents or unusual events.
    """,
}


def normalize_role(role: str) -> Role:
    cleaned_role = role.strip().lower().replace(" ", "_")
    for role_option in Role:
        if cleaned_role in {
            role_option.name.lower(),
            role_option.value.lower(),
            role_option.value.lower().replace(" ", "_"),
        }:
            return role_option
    raise HTTPException(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        detail=f"Unsupported role: {role}",
    )


@app.post("/add_members")
def add_members(
        body: AddMemberRequest,
        user_id: Annotated[str, Depends(get_current_user)],
        db: Session = Depends(get_db),
) -> dict[str, int | str]:
    user = db.get(User, int(user_id))
    if user is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    role = normalize_role(body.role)
    member = db.scalar(
        select(Member).where(
            Member.nick_name == body.nick_name,
            Member.phone_number == body.phone_number,
            Member.role == role,
        )
    )
    if member is None:
        member = Member(
            nick_name=body.nick_name,
            role=role,
            preferred_language=body.preferred_language,
            phone_number=body.phone_number,
        )
        db.add(member)

    if user not in member.users:
        member.users.append(user)

    db.commit()
    db.refresh(member)
    return {"member_id": member.id, "status": "added"}
