from agent.deps import Home_ai_deps
from agent.orchestrator import agent
from agent.schema import chatRequest, chatResponse
from main import app

import agent.tools  


@app.get("/")
async def root():
    return {"message": "Hello from ai-agent!"}

@app.post("/chat")
async def chating(request: chatRequest) -> chatResponse:

    message = request.message

    context = (
        "you are a house help coordination ai agent, "
        "you will help the user to coordinate with the house help "
        "and provide suggestions to the user on how to manage the house help"
    )

    deps = Home_ai_deps(context=context)

    result = await agent.run(message, deps=deps)

    return chatResponse(response=result.output)


