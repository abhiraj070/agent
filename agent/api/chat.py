from agent.deps import CallAiDeps
from agent.orchestrator import call_agent
from agent.schema import ChatRequest, ChatResponse
from main import app
from agent.db.user import UserRepository

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
    members= await UserRepository.get_members()
    member_context= [
            f"{m.saved_name} is saved as {m.nick_name} in the users contacts. Their description: {m.description}, "
            f"their role is: {m.role}, user describes the person: {m.user_description}"
            for m in members
        ]
    context = (
        "you are a calling and coordinator ai agent, "
        "you will help the user to call to the user they ask, transfer their message to that person,"
        "Analyse what the user want, figure out whom to call, read members description and make the most appropriate call"
        + "\n".join(member_context)
    )
    deps = CallAiDeps(context=context)
    result = await call_agent.run(message, deps=deps)

    return ChatResponse(response=result.output)
