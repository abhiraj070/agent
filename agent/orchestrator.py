from pydantic_ai import Agent, RunContext 
#from pydantic_ai.models.anthropic import AnthropicModel
#from pydantic_ai.providers.anthropic import AnthropicProvider
#from agent.config.settings import get_settings
from pydantic_ai.providers.ollama import OllamaProvider
from pydantic_ai.models.ollama import OllamaModel
from agent.deps import CallAiDeps

#_settings= get_settings()
model = OllamaModel(
    model_name="qwen3:8b",
    provider=OllamaProvider(base_url="http://localhost:11434/v1"),
)
agent= Agent(
    model=model,
    deps_type= CallAiDeps,
    output_type= str
)
call_agent = agent

@agent.instructions
def read_context(ctx: RunContext[CallAiDeps])-> str:
    return f"context: {ctx.deps.context}"
