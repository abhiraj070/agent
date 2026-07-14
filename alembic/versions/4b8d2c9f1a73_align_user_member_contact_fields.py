"""align user and member contact fields

Revision ID: 4b8d2c9f1a73
Revises: e674063700d9
Create Date: 2026-07-14 00:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "4b8d2c9f1a73"
down_revision: Union[str, Sequence[str], None] = "e674063700d9"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.add_column(
        "members",
        sa.Column("phone_number", sa.String(), nullable=False, server_default=""),
    )
    op.add_column(
        "members",
        sa.Column("preferred_language", sa.String(), nullable=False, server_default="English"),
    )
    op.add_column(
        "users",
        sa.Column("phone_number", sa.String(), nullable=False, server_default=""),
    )

    op.alter_column("members", "phone_number", server_default=None)
    op.alter_column("members", "preferred_language", server_default=None)
    op.alter_column("users", "phone_number", server_default=None)

    op.create_unique_constraint(
        "uq_members_nick_phone_role",
        "members",
        ["nick_name", "phone_number", "role"],
    )


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_constraint("uq_members_nick_phone_role", "members", type_="unique")
    op.drop_column("users", "phone_number")
    op.drop_column("members", "preferred_language")
    op.drop_column("members", "phone_number")
