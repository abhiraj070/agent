from fastapi import FastAPI
from faster_whisper import WhisperModel

app= FastAPI()

model = WhisperModel(
    "base",
    device="cpu",
    compute_type="int8",
)
import agent.api.chat
import agent.tools
import agent.api.rec
