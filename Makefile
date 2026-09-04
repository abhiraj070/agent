web-install:
	cd web_app && npm install

web:
	cd web_app && npm run dev

backend-install:
	uv sync

backend:
	uv run uvicorn main:app --reload
