from dataclasses import dataclass

@dataclass
class CallAiDeps:
    from_phone_number: str
    context: str
