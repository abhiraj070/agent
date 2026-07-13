from pydantic_ai import Agent, RunContext 
#from pydantic_ai.models.anthropic import AnthropicModel
#from pydantic_ai.providers.anthropic import AnthropicProvider
#from agent.config.settings import get_settings
from pydantic_ai.providers.ollama import OllamaProvider
from pydantic_ai.models.ollama import OllamaModel
from pydantic_ai.settings import ModelSettings
from agent.deps import CallAiDeps

#_settings= get_settings()
model = OllamaModel(
    model_name="qwen3:8b",
    provider=OllamaProvider(base_url="http://localhost:11434/v1"),
)
agent= Agent(
    model=model,
    deps_type= CallAiDeps,
    output_type= str,
    # Run every requested function call even if the model emits a final reply
    # in the same response.
    end_strategy="exhaustive",
    model_settings=ModelSettings(temperature=0,max_tokens=192,),
)
call_agent = agent

@agent.instructions
def read_context(ctx: RunContext[CallAiDeps])-> str:
    return f"context: {ctx.deps.context}"
