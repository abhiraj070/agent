from fastapi import fastapi, Request

app= fastapi()

@app.post("/chat")
async def chating()