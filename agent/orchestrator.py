from pydantic_ai import Agent, RunContext
from pydantic_ai.models.openai import OpenAIResponsesModel
from pydantic_ai.providers.openai import OpenAIProvider
from agent.config.settings import get_settings
#from pydantic_ai.providers.ollama import OllamaProvider
#from pydantic_ai.models.ollama import OllamaModel
from pydantic_ai.settings import ModelSettings
from agent.deps import CallAiDeps

_settings= get_settings()
model = OpenAIResponsesModel(
    model_name=_settings.AGENT_MODEL,
    provider=OpenAIProvider(api_key=_settings.OPENAI_API_KEY),
)
agent= Agent(
    model=model,
    deps_type= CallAiDeps,
    output_type= str,
    end_strategy="exhaustive",
    model_settings=ModelSettings(temperature=0,max_tokens=521),
)
call_agent = agent

@agent.instructions
def read_context(ctx: RunContext[CallAiDeps])-> str:
    return f"context: {ctx.deps.context}"
