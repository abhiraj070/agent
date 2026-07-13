from agent.deps import CallAiDeps
from agent.orchestrator import call_agent
from agent.schema import ChatRequest, ChatResponse
from main import app

USER_NAME = "Abhiraj"

@app.get("/")
async def root():
    #TODO: connect the api contact picker
    #TODO: connect google OAuth for Google contacts
    #TODO: take users phone number-> for identifying me
    return {"message": "Hello from ai-agent!"}

@app.post("/chat")
async def chat(request: ChatRequest) -> ChatResponse:
    print("request reached")
    message = request.message
    user_name= USER_NAME
    #user_id= request.user.id
    #members= await UserRepository.get_members()
    members={
        "maid": {
            "nick_name": "maid",
            "role": "maid",
            "description": """
                Responsible for routine household chores and cleanliness.
                Primary responsibilities:
                - Carrying out general cleaning and maintenance tasks.
                - Receiving household-related instructions from the user.
            """,
        },

        "cook": {
            "nick_name": "cook",
            "role": "cook",
            "description": """
                Responsible for all cooking and meal preparation.
                Primary responsibilities:
                - Preparing breakfast, lunch, dinner, snacks, tea, coffee, and other beverages.
                - Handling requests related to meals and food preparation.
            """,
        },

        "driver": {
            "nick_name": "driver",
            "role": "driver",
            "description": """
                Responsible for transportation and travel assistance.
                Primary responsibilities:
                - Driving the user or family members.
                - Pickup and drop-off arrangements.
            """,
        },
    }
    member_context= [
            f"{members[m]["nick_name"]}: {members[m]["role"]}"
            for m in members
        ]
    context = (
        "Route calls fast. Split the request by household member. "
        "Call call_someone once per requested member, then move on. "
        "Never repeat a member or combine instructions. "
        f"Use one short sentence starting with '{user_name} asked me to ask/tell you'. "
        "Contacts: " + ", ".join(member_context)
    )
    #deps = CallAiDeps(context=context,user_id=user_id)
    deps = CallAiDeps(context=context)

    result = await call_agent.run(message, deps=deps)

    return ChatResponse(response=result.output)
