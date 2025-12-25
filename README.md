# 🚀 Sync'd — Multiplayer Social Gaming Platform

**Sync’d** is a social gaming platform that makes **local-multiplayer-only Android games playable over the internet**. It connects players through real-time input synchronization, screen sharing, and community features — all inside a single mobile app. 

This repository contains both the **Flutter frontend** and the **Spring Boot + PostgreSQL backend** that power the experience.

---

## ⚡ Quick Start for All Developers

### 🧩 Requirements

| Tool | macOS | Windows |
| :--- | :--- | :--- |
| **Java 17+** | `brew install openjdk@17` | [Download JDK 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html) |
| **Maven 3.9+** | `brew install maven` | [Download Maven](https://maven.apache.org/download.cgi) |
| **PostgreSQL 14+** | `brew install postgresql` | [PostgreSQL Installer](https://www.postgresql.org/download/windows/) |
| **Flutter SDK** | [Install Flutter](https://docs.flutter.dev/get-started/install/macos) | [Install Flutter](https://docs.flutter.dev/get-started/install/windows) |
| **IDE** | VS Code / Android Studio | Any IDE with Java & Dart support |

---

## 🧱 Project Structure

```text
Syncd-ARCP/
├── frontend/                     # Flutter frontend (Glassmorphism UI)
│   ├── lib/
│   │   ├── services/             # Socket, WebRTC, App Scan Services
│   │   ├── screens/              # Host, Join, Game Stream, Squads
│   │   └── widgets/              # Reusable UI components
│   └── pubspec.yaml
│
├── backend/                      # Java Spring Boot backend
│   ├── src/
│   │   ├── main/java/com/syncd/syncd_backend/
│   │   │   ├── controller/       # REST (Auth, Lobby) & WebSocket Controllers
│   │   │   ├── service/          # Business Logic & Chat Persistence
│   │   │   ├── repository/       # JPA Repositories
│   │   │   ├── model/            # Database Entities (User, Squad, GameLib)
│   │   │   ├── dto/              # Data Transfer Objects
│   │   │   ├── config/           # Security, JWT & WebSocket Configuration
│   │   │   └── SyncdBackendApplication.java
│   │   └── resources/
│   │       └── application.yaml
│   ├── pom.xml
│   └── target/
└── README.md
```

---

## 👥 Team & Roles

| Role | Name | Responsibilities | GitHub |
| :--- | :--- | :--- | :--- |
| 🧠 **Backend & Core (Dev A)** | **Nehal Ajmal** | Core Backend, Real-Time Engine (WebSockets), Security/Auth, Game Sync Logic | [@nehalajmal](https://github.com/NehalAjmal) |
| ⚡ **Advanced Features (Dev B)** | **Navistha Pandey** | Screen Sharing (WebRTC), App Scanning, Squads, Advanced User Data | [@navisthapandey](https://github.com/Navistha) |
| 🎨 **Frontend (Dev C)** | **Mohd Amaan** | Flutter Frontend, UI/UX, Service Integration | [@Erichthonius07](https://github.com/Erichthonius07) |

---

## ✅ Work Completed So Far

### 🧠 Backend & Core Engine (Developer A – Nehal Ajmal)
* **Core Infrastructure:**
    * Spring Boot project initialization with Maven & PostgreSQL.
    * **Security Architecture:** `SecurityConfig`, BCrypt password encryption, and JWT Token generation/validation.
* **Real-Time Engine (WebSocket + STOMP):**
    * Configured `WebSocketConfig` with STOMP endpoints at `/ws-sync` and SockJS fallback.
    * Created `WebSocketAuthInterceptor` to validate JWTs in the handshake headers, securing the real-time layer.
* **Game & Input Synchronization:**
    * **Virtual Controller Logic:** Implemented `GameInput` DTO for low-latency button presses.
    * **Player Slots:** Logic to map inputs to specific slots (1-4) for split-screen gaming.
    * **Broadcasting:** Routing logic in `GameController` to broadcast inputs to lobby topics (`/topic/game/{gameCode}`).
* **REST Modules:**
    * **User Auth:** Register/Login APIs.
    * **Friend Management:** Add, Accept, Decline, List Friends.
    * **Activity Feed:** Track and display user activities.
    * **Chat History:** Persistent chat storage and retrieval.
    * **Lobby Management:** Create and Join Game Lobbies.

### ⚡ Advanced Features & Media (Developer B – Navistha Pandey)
* **Screen Sharing & Streaming:**
    * **WebRTC Implementation:** Built the logic for Peer-to-Peer video streaming (Host screen to Guest).
    * **Signaling:** Handling SDP (Offer/Answer) and ICE Candidate exchange for establishing video pipes.
* **App Scanning & Game Library:**
    * **Device Scan:** Logic to scan the user's device for installed apps.
    * **Game Library:** Allow users to add specific apps to their "Sync'd Library" to host them later.
    * **User-Specific Data:** Enhanced data models to hold user-specific game preferences and library states.
* **Squads & Social Rooms:**
    * **Squad Architecture:** Created data models and logic for "Squads" (persistent groups).
    * **Room Management:** Logic for game rooms and inviting specific people/squads to join a session.

### 🎨 Frontend (Developer C – Mohd Amaan)
* Full Flutter UI built and functional.
* Custom glassmorphism design + glitch splash screen.
* Navigation and Provider-based state management.
* Integration of `SocketService` and `WebRTCService`.
* UI implementation for Game Streaming, Virtual Controller, and App Library.

### ⚙️ Environment Verified
- **Backend** runs successfully via `mvn spring-boot:run`.
- **Tomcat** starts on port `8080`.
- **PostgreSQL** connected and all tables (`users`, `friend_requests`, `activities`, `messages`, `lobbies`) are created/updated automatically.
- All endpoints tested in **Postman**.

---

## 🗄️ Database Setup (Mac & Windows)

### 1️⃣ Create Database
```bash
psql -U postgres
CREATE DATABASE syncd;
\q
```

### 2️⃣ Configure Credentials
Create a local-only config file (this file is ignored by Git).

```bash
cd backend/src/main/resources
touch application.yaml
```

**Add this content to `application.yaml`:**
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/syncd
    username: postgres
    password: your_postgres_password
```

---

## 💻 Running the Backend

**macOS / Linux / Windows**
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

**✅ You should see:**
> Tomcat started on port 8080
> Started SyncdBackendApplication

---

## 📱 Running the Mobile App

**Note:** For the Host features (Screen Share + Touch Injection) to work, you must run this on an **Android Device** (Emulator or Physical).

```bash
cd frontend
flutter pub get
flutter run
```

---

## 🧪 Test with Postman

### 1. Register & Login
* **POST** `http://localhost:8080/api/auth/login`
* **Response:** Returns `{"token": "eyJhbGci..."}`. **Copy this token** for WebSocket testing.

### 2. WebSocket Testing (SmartPost / Postman)
* **URL:** `ws://localhost:8080/ws-sync`
* **Headers:** `Authorization: Bearer <your_token>`
* **Subscribe:** `/topic/game/ABCD` (to listen for inputs)
* **Send Destination:** `/app/game/input`

**JSON Payload:**
```json
{
  "gameCode": "ABCD",
  "playerSlot": 1,
  "inputData": "BTN_A_PRESS"
}
```

---

## 🔧 Useful Commands

| Task | Command |
| :--- | :--- |
| **Start PostgreSQL** | `brew services start postgresql` (Mac) / `pg_ctl start` (Win) |
| **Access DB shell** | `psql -U postgres` |
| **Build backend** | `mvn clean install` |
| **Run backend** | `mvn spring-boot:run` |
| **Run frontend** | `flutter run` |

---

## 🔧 Troubleshooting

* **WebSocket Error 401/403:** Ensure the JWT token is being passed correctly in the `Authorization: Bearer` header during the STOMP handshake.
* **Video Black Screen:** Ensure both devices are on networks that allow P2P WebRTC traffic (or configure a TURN server).
* **Touches Not Working:** The Host **must** enable the "Sync'd Accessibility Service" in their phone's Accessibility settings.

---

## 🧾 License

© 2025 **Sync’d Development Team** — All Rights Reserved.  
Built collaboratively using **Spring Boot**, **PostgreSQL**, and **Flutter**.