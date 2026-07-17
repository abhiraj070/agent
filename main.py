from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
app= FastAPI()

app.mount("/audio", StaticFiles(directory="audio"), name="audio")
import agent.api.chat
import agent.tools
import agent.api.websocket
import agent.api.rec
import agent.api.member
import agent.api.start
import agent.api.status
import agent.api.user
