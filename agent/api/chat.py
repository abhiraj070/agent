from agent.deps import Home_ai_deps
from agent.orchestrator import home_agent
from agent.schema import ChatRequest, ChatResponse
from main import app

@app.get("/")
async def root():
    return {"message": "Hello from ai-agent!"}

@app.post("/chat")
async def chat(request: ChatRequest) -> ChatResponse:
    print("request reached")
    message = request.message
    context = (
        "you are a house help coordination ai agent, "
        "you will help the user to coordinate with the house help "
        "and provide suggestions to the user on how to manage the house help"
    )
    deps = Home_ai_deps(context=context)
    result = await home_agent.run(message, deps=deps)

    return ChatResponse(response=result.output)
