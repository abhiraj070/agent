from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
app= FastAPI()

app.mount("/audio", StaticFiles(directory="audio"), name="audio")
import agent.api.chat
import agent.tools
import agent.api.rec
import agent.api.member
