# Project Guidelines

## General
- Keep changes minimal in backend.
- Never refactor unrelated code.
- Ask before changing public APIs.

## Searching
- Never inspect node_modules unless absolutely necessary.
- Ignore .venv, dist, build, and .next.
- Prefer rg over grep.

## Backend
- Do not touch backend files until necessary ask first.
- Use async SQLAlchemy.
- Reuse existing services before creating new ones.
- Follow the existing dependency injection pattern.

## Frontend
- Frontend is a mobile app
- Use Flutter (stable) and Dart.

Architecture
- Feature-first folder structure.
- Clean Architecture.
- Repository pattern.
- Riverpod for state management and dependency injection.

Dependencies
- Prefer Flutter SDK before third-party packages.
- Only use mature, actively maintained packages.
- Explain why each new dependency is required.
- Keep pubspec.yaml minimal.

Networking
- Use Dio.
- Use interceptors for authentication, logging, and retries.

Routing
- Use GoRouter.

Models
- Use Freezed and json_serializable.

Storage
- Use flutter_secure_storage for secrets.
- Use SharedPreferences for simple preferences.
- Introduce Hive only when structured offline storage is required.

Performance
- Target smooth 60/120 FPS.
- Minimize widget rebuilds.
- Use const constructors where possible.
- Avoid blocking the UI thread.
- Implement lazy loading and pagination.
- Cache network images.

Code Quality
- Keep changes minimal.
- Reuse existing components.
- Avoid duplicate code.
- Do not refactor unrelated files without approval.
- Explain the implementation plan before coding.
- Take UI_design as a reference for building frontend components
