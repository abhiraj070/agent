from agent.orchestrator import call_agent
from agent.deps import CallAiDeps


async def run_agent(members, phone_number, connection_id, message):
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
    return await call_agent.run(message, deps=deps)