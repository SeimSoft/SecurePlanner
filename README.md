# Secure Planner

A high-security, local-first todo and project management application with end-to-end encryption and seamless server synchronization.

## Features

- **Local-First Security**: Use the app entirely offline. Your data is protected by a Master Key created on first launch.
- **End-to-End Encryption**: Data is encrypted on your device before being synced. The server never sees your plain-text data.
- **Biometric Lock**: Protect your app with FaceID, TouchID, or Fingerprint authentication.
- **Secure Onboarding**: Connect to a server via a secure one-time QR code.
- **Multi-Platform**: Available for Android, Windows, Linux, and macOS.
- **Local-Only Categories**: Mark specific categories to never leave your device (ideal for sensitive work data).
- **Embedded Database**: Uses SQLite (via Drift) for high-performance local storage.

---

## Backend Setup (Golang)

The backend provides a secure relay for synchronizing your encrypted data across devices.

### 🐳 Using Docker (Recommended)

1. **Create an environment file** `.env`:
   ```env
   AUTO_UPDATE_ENABLED=true
   ```

2. **Run the container**:
   ```bash
   docker run -d \
     -p 8080:8080 \
     --env-file .env \
     -v $(pwd)/data:/app/data \
     --name secure-planner-backend \
     seimsoft/secure-planner-backend:latest
   ```

### 🛠 Manual Setup

1. **Prerequisites**: Go 1.25+ installed.
2. **Build the binary**:
   ```bash
   cd backend
   go build -o backend_app cmd/main.go
   ```
3. **Run the server**:
   ```bash
   chmod +x backend_app
   ./backend_app
   ```
   *The server will create a `planner.db` locally by default.*

---

## Getting Started (Mobile App)

1. **Onboarding**: On the first launch, create a strong Master Key. This key is used to derive your encryption keys.
2. **Biometrics**: Enable biometrics for quick access.
3. **Connecting to Server**:
   - As an admin, use the `/admin/create-user` endpoint to generate a QR code.
   - In the app, choose "Connect to Server" on the login screen.
   - Scan the QR code to automatically configure the server URL and authenticate.

## Development

### Flutter App
- Requires Flutter SDK (Stable channel).
- Run `flutter pub get` and then `flutter run`.
- To rebuild database models: `dart run build_runner build`.

### Backend
- The backend features an **Auto-Update** mechanism. It checks GitHub for new releases on startup.
- You can disable this by setting `AUTO_UPDATE_ENABLED=false`.

## License
MIT
