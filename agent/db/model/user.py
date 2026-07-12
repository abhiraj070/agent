from sqlalchemy import Column, Integer, String, ForeignKey, Enum as SqlEnum
from sqlalchemy.orm import relationship
from agent.db.connect import base
from enum import Enum


class Role(str, Enum):
    Maid = "Maid"
    Driver = "Driver"
    Cook = "Cook"
    Gardner = "Gardner"
    House_Manager = "House_Manager"
    Nanny = "Nanny"
    Dog_Walker = "Dog_Walker"
    Maintenance = "Maintenance"
    Security = "Security"
    Family = "Family"
    Friend = "Friend"
    NONE = "None"

class UserMember(base):
    __tablename__ = "user_member"
    user_id = Column(Integer,ForeignKey("users.id"), primary_key=True)
    member_id=Column(Integer, ForeignKey('members.id'), primary_key=True)

class Member(base):
    __tablename__ = "members"
    id = Column(Integer, primary_key=True)
    contact_name = Column(String, default="")
    description = Column(String, default="")
    nick_name= Column(String, default="")
    role=Column(SqlEnum(Role, name="role"), default=Role.NONE, nullable=False)
    user_description = Column(String, default="")
    users= relationship(
        "User",
        secondary="user_member",
        back_populates="members"
    )

class User(base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    members = relationship(
        "Member",
        secondary="user_member",
        back_populates="users"
    )
