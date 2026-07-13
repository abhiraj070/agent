from dataclasses import dataclass

@dataclass
class CallAiDeps:
    user_id: int
    context: str
