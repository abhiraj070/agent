"""revert extra user and member fields

Revision ID: 9c1f0d2e7b64
Revises: 4b8d2c9f1a73
Create Date: 2026-07-14 00:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "9c1f0d2e7b64"
down_revision: Union[str, Sequence[str], None] = "4b8d2c9f1a73"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.drop_column("members", "user_description")
    op.drop_column("members", "description")
    op.drop_column("members", "contact_name")
    op.drop_column("users", "name")


def downgrade() -> None:
    """Downgrade schema."""
    op.add_column("users", sa.Column("name", sa.String(), nullable=False, server_default=""))
    op.alter_column("users", "name", server_default=None)
    op.add_column("members", sa.Column("contact_name", sa.String(), nullable=True))
    op.add_column("members", sa.Column("description", sa.String(), nullable=True))
    op.add_column("members", sa.Column("user_description", sa.String(), nullable=True))
