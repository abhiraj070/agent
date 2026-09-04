# Aaraam Call Agent

Aaraam is an AI-assisted household calling app. It lets a user describe an instruction in text or voice, identifies the relevant household member from the user's saved contacts, and places an outbound phone call that delivers the message in natural spoken language.

The project combines a FastAPI backend, an AI call-routing agent, Twilio calling, ElevenLabs text-to-speech, OpenAI transcription, and a Flutter mobile app. It is designed for day-to-day household coordination: asking the cook to prepare something, telling the driver about a pickup, asking a house manager to get the home ready, or sending separate instructions to multiple people from one request.

## What This Project Does

- Authenticates users through Twilio OTP.
- Stores users, household members, preferred languages, roles, and activity history.
- Accepts text instructions and uploaded voice notes from the mobile app.
- Uses an AI agent to decide who should be called and what message each person should receive.
- Places real outbound calls through Twilio.
- Generates spoken audio with ElevenLabs and serves it to Twilio during the call.
- Records call responses, downloads them from Twilio, transcribes them with OpenAI Whisper, and streams call status back to the client over WebSockets.
- Provides a Flutter mobile interface for onboarding, people management, activity history, voice input, and task execution.

## Architecture

```text
Flutter Mobile App
        |
        | REST: auth, members, activity, chat, audio
        | WebSocket: live connection id and call status
        v
FastAPI Backend
        |
        | Auth / user state / activity persistence
        v
SQLAlchemy Database

FastAPI Backend
        |
        | user request + household context
        v
Pydantic AI Agent
        |
        | tool call: call_someone(...)
        v
Twilio Voice Call
        |
        | generated MP3
        v
ElevenLabs Text-to-Speech

Twilio Recording Callback
        |
        | downloaded recording
        v
OpenAI Whisper Transcription
        |
        | status / transcript
        v
Flutter Mobile App
```

### Backend

The backend is a Python FastAPI service rooted at `main.py`. Routes are registered by importing modules under `agent/api`.

Key backend areas:

- `agent/api/start.py` handles OTP login and JWT token generation.
- `Auth/VerifyJWT.py` validates access tokens and refreshes access tokens when a valid refresh token is present.
- `agent/api/member.py` manages household members and supported roles.
- `agent/api/chat.py` accepts text or audio instructions, runs the AI agent, and stores activity records.
- `agent/api/websocket.py` creates live WebSocket connections used for call status updates.
- `agent/api/status.py` receives Twilio call status callbacks and forwards them to the active WebSocket.
- `agent/api/rec.py` receives Twilio recording callbacks and starts transcription work.
- `agent/orchestrator.py`, `agent/run_agent.py`, and `agent/tools.py` define the Pydantic AI agent and its `call_someone` tool.
- `utils/make_call.py`, `utils/generate_audio.py`, and `utils/download_audio.py` integrate Twilio, ElevenLabs, and OpenAI transcription.
- `agent/db/model/user.py` defines the SQLAlchemy models for users, members, user-member links, and activities.

### Mobile App

The Flutter app lives in `mobile/`. It follows a feature-first structure with clear application, data, domain, presentation, and core layers.

Key mobile areas:

- `mobile/lib/presentation/` contains screens and widgets for onboarding, home, people, activity, and shared sheets.
- `mobile/lib/application/` contains Riverpod controllers and providers for app state.
- `mobile/lib/data/remote/` contains Dio-backed API repositories for auth, users, members, chat, audio, and calls.
- `mobile/lib/data/local/` contains local repositories for preferences, onboarding state, activity cache, people data, audio recording, and secure token storage.
- `mobile/lib/domain/entities/` contains app-level domain entities.

The mobile app talks to the backend through REST endpoints and maintains a WebSocket connection so the backend can stream live call progress and transcripts.

### UI Design Prototype

The `UI_design/` directory contains a separate web/design prototype built with Next.js, React, TypeScript, Tailwind CSS, Drizzle, Vite/Vinext, and Cloudflare tooling. It appears to serve as a visual reference for the product experience rather than the primary production client.

### Data Model

The core backend data model is intentionally small:

- `User`: stores the user's phone number and preferred language.
- `Member`: stores household contact details, role, nickname, and preferred language.
- `UserMember`: joins users and members.
- `Activity`: stores requests, agent responses, and timestamps.

Database migrations are managed with Alembic in `alembic/`.

## Tech Stack

### Backend

- Python 3.13+
- FastAPI
- Uvicorn
- Pydantic AI
- Pydantic Settings
- SQLAlchemy
- Alembic
- python-jose for JWT handling
- httpx
- python-multipart

### AI, Voice, and Telephony

- OpenAI Responses API through Pydantic AI
- OpenAI Whisper transcription
- ElevenLabs text-to-speech
- Twilio Voice
- Twilio Verify for OTP authentication

### Mobile

- Flutter
- Dart
- Riverpod
- Dio
- flutter_secure_storage
- shared_preferences
- record
- path_provider

### Web Design Prototype

- Next.js
- React
- TypeScript
- Tailwind CSS
- Drizzle ORM
- Vite / Vinext
- Cloudflare Wrangler

## Why Use This Project

Use this project if you want an AI-native way to coordinate household operations without manually calling each person yourself. Aaraam is useful when:

- The user wants to send one natural-language instruction and let the system route it.
- Different household members need different instructions from the same request.
- Calls are more reliable than app notifications or chat messages.
- Spoken communication in each member's preferred language matters.
- The user needs call progress, response recordings, transcripts, and activity history in one place.

The core value is that it turns a simple instruction like "Tell the cook to make dinner early and ask the driver to be ready at 7" into separate, role-aware phone calls with the right message delivered to the right person.

## Environment Variables

The backend reads configuration from `.env` through `agent/config/settings.py`.

Required values:

```env
AGENT_MODEL=
OPENAI_API_KEY=
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_SERVICE_SID=
NGROK_BASE_URL=
DATABASE_URL=
ELEVEN_LABS_API_KEY=
VOICE_ID=
SECRET_KEY=
REFRESH_TOKEN_EXPIRE_DAYS=
ACCESS_TOKEN_EXPIRE_MINUTES=
```

`NGROK_BASE_URL` must point to a public HTTPS URL for the FastAPI server, because Twilio needs to reach the backend for audio playback, call status callbacks, and recording callbacks.

## Running Locally

### Makefile Shortcuts

From the repository root:

```bash
make web-install
make web

make backend-install
make backend

```

The web app and backend commands are intended to run in separate terminals.

### Backend

```bash
uv sync
uv run uvicorn main:app --reload
```

The backend serves generated call audio from `/audio`.

### Mobile

```bash
cd mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:8000
```

For Android emulator development, use:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

### UI Design Prototype

```bash
cd UI_design
npm install
npm run dev
```

## API Surface

Important backend endpoints include:

- `POST /send-otp`
- `POST /verify-otp`
- `PATCH /add-language`
- `POST /add_members`
- `GET /get-my-members`
- `GET /get-my-activity`
- `POST /delete-my-activity`
- `POST /recieve-message`
- `POST /receive-audio-file`
- `WebSocket /ws`
- `POST /call-status`
- `POST /process_recording`
- `POST /recording_finished`

## Project Structure

```text
.
├── Auth/                 # JWT validation and token refresh helpers
├── agent/                # FastAPI routes, AI agent, database models, config
├── alembic/              # Database migrations
├── mobile/               # Flutter mobile app
├── UI_design/            # Web/design prototype
├── utils/                # Twilio, audio generation, and transcription helpers
├── main.py               # FastAPI app entrypoint
├── pyproject.toml        # Python project dependencies
└── alembic.ini           # Alembic configuration
```
