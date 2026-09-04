from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
app= FastAPI()

app.mount("/audio", StaticFiles(directory="audio"), name="audio")
import server.agent.api.chat
import server.agent.tools
import server.agent.api.websocket
import server.agent.api.rec
import server.agent.api.member
import server.agent.api.start
import server.agent.api.status
import server.agent.api.user
