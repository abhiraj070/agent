from sqlalchemy import Column, Integer, String, ForeignKey, Enum as SqlEnum, UniqueConstraint
from sqlalchemy.orm import relationship
from agent.db.connect import base
from enum import Enum


class Role(str, Enum):
    Maid = "Maid"
    Driver = "Driver"
    Cook = "Cook"
    Gardner = "Gardner"
    House_Manager = "House Manager"
    Nanny = "Nanny"
    Dog_Walker = "Dog Walker"
    Maintenance = "Maintenance"
    Security = "Security"
    OTHER = "None"

class UserMember(base):
    __tablename__ = "user_member"
    user_id = Column(Integer,ForeignKey("users.id"), primary_key=True)
    member_id=Column(Integer, ForeignKey('members.id'), primary_key=True)

class Member(base):
    __tablename__ = "members"
    id = Column(Integer, primary_key=True)
    nick_name= Column(String, default="")
    phone_number= Column(String, nullable=False)
    role=Column(SqlEnum(Role, name="role"), default=Role.OTHER, nullable=False)
    preferred_language= Column(String, nullable=False)
    users= relationship(
        "User",
        secondary=UserMember.__table__,
        back_populates="members"
    )
    __table_args__ = (
        UniqueConstraint("nick_name", "phone_number", "role", name="uq_members_nick_phone_role"),
    )

class User(base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    phone_number= Column(String, nullable=False)
    preferred_language= Column(String)
    members = relationship(
        "Member",
        secondary=UserMember.__table__,
        back_populates="users"
    )
