# 🚀 Sync'd — Multiplayer Social Gaming Platform

**Sync’d** is a social gaming platform that makes **local-multiplayer-only Android games playable over the internet**.
It connects players through real-time input synchronization, chat, and community features — all inside a single mobile app.

This repository contains both the **Flutter frontend** and the **Spring Boot + PostgreSQL backend** that power the experience.

-----

## ⚡ Quick Start for All Developers

### 🧩 Requirements

| Tool | macOS | Windows |
| :--- | :--- | :--- |
| **Java 17+** | `brew install openjdk@17` | [Download JDK 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html) |
| **Maven 3.9+** | `brew install maven` | [Download Maven](https://maven.apache.org/download.cgi) |
| **PostgreSQL 14+** | `brew install postgresql` | [PostgreSQL Installer](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads) |
| **Flutter SDK** | [Install Flutter](https://flutter.dev/docs/get-started/install/macos) | [Install Flutter](https://flutter.dev/docs/get-started/install/windows) |
| **VS Code / Android Studio** | Any IDE with Java & Dart support | Same |

-----

## 🧱 Project Structure (Updated)

```
Syncd-ARCP/
├── frontend/                     # Flutter frontend (mock-data-based)
│   ├── lib/
│   └── pubspec.yaml
│
├── backend/                      # Java Spring Boot backend
│   ├── src/
│   │   ├── main/java/com/syncd/syncd_backend/
│   │   │   ├── controller/     # Auth, Friend, Activity, Chat, Lobby
│   │   │   ├── service/        # User, Friend, Activity, Chat, Lobby
│   │   │   ├── repository/     # User, Friend, Activity, Message, Lobby
│   │   │   ├── model/          # User, FriendRequest, Activity, Message, Lobby
│   │   │   ├── config/         # SecurityConfig
│   │   │   └── SyncdBackendApplication.java
│   │   └── resources/
│   │       └── application.yaml
│   ├── pom.xml
│   └── target/
└── README.md
```

-----

## ✅ Work Completed So Far (Updated)

### 🧠 Backend (Developer A – Nehal Ajmal)

  * Spring Boot project initialized with Maven & PostgreSQL.
  * Password encryption with **BCrypt** (`SecurityConfig`).
  * **Module 1: User Authentication**
      * `POST /api/auth/register`
      * `POST /api/auth/login`
  * **Module 2: Friend Management**
      * `POST /api/friends/add`
      * `GET /api/friends`
      * `GET /api/friends/requests`
      * `POST /api/friends/accept/{id}`
      * `POST /api/friends/decline/{id}`
  * **Module 3: Activity Feed**
      * `GET /api/activity`
      * `POST /api/activity/add`
      * `DELETE /api/activity/all`
  * **Module 4: Chat History**
      * `GET /api/chat/{friendUsername}`
  * **Module 5: Lobby Management**
      * `POST /api/lobby/create`
      * `POST /api/lobby/join`

### 🎨 Frontend (Developer C)

  * Full Flutter UI built and functional.
  * Custom glassmorphism design + glitch splash screen.
  * Navigation and Provider-based state management working.
  * Currently uses **mock data** in `lib/services/` (no API calls yet).

### ⚙️ Environment Verified

  * Backend runs successfully via `mvn spring-boot:run`.
  * Tomcat starts on port `8080`.
  * PostgreSQL connected and all tables (`users`, `friend_requests`, `activities`, `messages`, `lobbies`) are created/updated automatically.
  * All endpoints tested in Postman.

-----

## 🗄️ Database Setup (Mac & Windows)

### 1️⃣ Create Database

```bash
psql -U postgres
CREATE DATABASE syncd;
\q
```

### 2️⃣ Configure Credentials

Create a local-only config file. This file is ignored by Git.

```bash
cd backend/src/main/resources
# cp application-example.yaml application.yaml  (if you have an example)
# Or just create the file:
touch application.yaml
```

```yaml
# Add this content to application.yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/syncd
    username: postgres
    password: your_postgres_password
```

-----

## 💻 Running the Backend

### macOS / Linux

```bash
cd backend
mvn clean install
mvn spring-boot:run
```

### Windows (cmd or PowerShell)

```bash
cd backend
mvn clean install
mvn spring-boot:run
```

✅ You should see:

```
Tomcat started on port 8080
Started SyncdBackendApplication
```

-----

## 🧪 Test with Postman (Updated Examples)

### 1\. Register Users

Register "nehal" and "amaan":

```
POST http://localhost:8080/api/auth/register
Content-Type: application/json
```

```json
{
  "username": "nehal",
  "email": "nehal@gmail.com",
  "password": "test123"
}
```

```json
{
  "username": "amaan",
  "email": "amaan@gmail.com",
  "password": "test123"
}
```

### 2\. Send Friend Request

"nehal" sends a request to "amaan":

```
POST http://localhost:8080/api/friends/add?sender=nehal&receiver=amaan
```

### 3\. Get/Accept Request

Get "amaan's" pending requests:

```
GET http://localhost:8080/api/friends/requests?username=amaan
```

> **Response:**
> `[ { "id": 1, "sender": "nehal", "receiver": "amaan", "status": "PENDING" } ]`

Use the `id` (e.g., `1`) to accept:

```
POST http://localhost:8080/api/friends/accept/1
```

### 4\. Create Lobby

"nehal" hosts a game:

```
POST http://localhost:8080/api/lobby/create?hostUsername=nehal
```

> **Response:**
> `{ "id": 1, ..., "gameCode": "A4T7", "hostUsername": "nehal", ... }`

### 5\. Join Lobby

"amaan" joins "nehal's" lobby using the `gameCode`:

```
POST http://localhost:8080/api/lobby/join?gameCode=A4T7&participantUsername=amaan
```

-----

## 💡 Frontend Notes

  * The Flutter app currently consumes mock data.
  * All API services in `lib/services/` are ready for integration. The frontend team can now begin replacing the mock data with live `http` calls to the `localhost:8080` endpoints.

-----

## 🔧 Useful Commands

| Task | macOS | Windows |
| :--- | :--- | :--- |
| Start PostgreSQL | `brew services start postgresql` | `pg_ctl -D "C:\Program Files\PostgreSQL\14\data" start` |
| Stop PostgreSQL | `brew services stop postgresql` | `pg_ctl stop` |
| Access DB shell | `psql -U postgres` | `psql -U postgres` |
| Build backend | `mvn clean install` | `mvn clean install` |
| Run backend | `mvn spring-boot:run` | `mvn spring-boot:run` |
Storage
| Run frontend | `flutter run` | `flutter run` |

-----

## 🔄 Git Workflow

```bash
# clone
git clone https://github.com/<org>/Syncd-ARCP.git

# create feature branch
git checkout -b backend/feature-lobby

# commit changes
git add .
git commit -m "feat: added lobby management module"

# push
git push origin backend/feature-lobby
```

-----

## 👥 Team

| role | Name | Role |
| :--- | :--- | :--- |
| 🧠 Developer A | Nehal Ajmal | Backend REST API & Database |
| ⚡ Developer B | Navistha Pandey | WebSocket & Real-Time Engine |
| 🎨 Developer C | Mohd Amaan | Flutter Frontend (UI & UX) |

-----

## 🧾 License

© 2025 **Sync’d Development Team** — All Rights Reserved.
Built collaboratively using **Spring Boot**, **PostgreSQL**, and **Flutter**.

-----