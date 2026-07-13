from agent.deps import CallAiDeps
from agent.orchestrator import call_agent
from agent.schema import ChatRequest, ChatResponse
from main import app

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
    user_name= "Abhiraj"
    #user_id= request.user.id
    #members= await UserRepository.get_members()
    members={
        "maid": {
            "contact_name": "maid",
            "nick_name": "maid",
            "role": "maid",
            "user_description": "",
            "description": """
                Responsible for routine household chores and cleanliness.
                Primary responsibilities:
                - Cleaning rooms and common areas.
                - Sweeping, mopping, dusting, and organizing.
                - Washing utensils, doing laundry, and other household chores.
                - Carrying out general cleaning and maintenance tasks.
                - Receiving household-related instructions from the user.
                This person should handle requests related to cleaning, laundry, and general household chores.
            """,
        },

        "cook": {
            "contact_name": "cook",
            "nick_name": "cook",
            "role": "cook",
            "user_description": "",
            "description": """
                Responsible for all cooking and meal preparation.
                Primary responsibilities:
                - Preparing breakfast, lunch, dinner, snacks, tea, coffee, and other beverages.
                - Following meal or recipe instructions.
                - Preparing food for specific occasions or guests.
                - Handling requests related to meals and food preparation.
                - Managing cooking-related grocery or ingredient requests when instructed.
                This person should handle any request related to cooking, meals, or food preparation.
            """,
        },

        "driver": {
            "contact_name": "driver",
            "nick_name": "driver",
            "role": "driver",
            "user_description": "",
            "description": """
                Responsible for transportation and travel assistance.
                Primary responsibilities:
                - Driving the user or family members.
                - Pickup and drop-off arrangements.
                - Airport, railway station, office, school, and other travel.
                - Preparing the vehicle before scheduled travel.
                - Handling transportation-related instructions.
                This person should handle requests involving travel, transportation, pickups, drop-offs, or vehicle-related assistance.
            """,
        },
    }
    member_context= [
            f"{members[m]["nick_name"]}: {members[m]["role"]}"
            for m in members
        ]
    context = (
        "You route household requests to one contact and place the call immediately. "
        "Use call_someone exactly once for a request to notify, instruct, or ask a household member. "
        f"Make its message concise and natural: begin with '{user_name} asked me to …'. "
        "Contacts: " + ", ".join(member_context)
    )
    #deps = CallAiDeps(context=context,user_id=user_id)
    deps = CallAiDeps(context=context)

    result = await call_agent.run(message, deps=deps)

    return ChatResponse(response=result.output)
