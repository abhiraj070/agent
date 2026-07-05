from pydantic_ai import Agent, RunContext 
from pydantic_ai.models.anthropic import AnthropicModel
from pydantic_ai.providers.anthropic import AnthropicProvider

from agent.config.settings import get_settings
from agent.deps import Home_ai_deps

print("Initializing the orchestrator...")

_settings= get_settings()

agent= Agent(
    model=AnthropicModel(
        _settings.AGENT_MODEL,
        provider=AnthropicProvider(api_key=_settings.ANTHROPIC_API_KEY)
    ),
    deps_type= Home_ai_deps,
    output_type= str
)

@agent.instructions
def readContext(ctx: RunContext[Home_ai_deps])-> str:
    return f"context: {ctx.deps.context}"
