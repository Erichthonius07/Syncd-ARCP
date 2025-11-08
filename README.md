# 🚀 Sync'd — Multiplayer Social Gaming Platform

**Sync’d** is a social gaming platform that makes **local-multiplayer-only Android games playable over the internet**.
It connects players through real-time input synchronization, chat, and community features — all inside a single mobile app.

This repository contains both the **Flutter frontend** and the **Spring Boot + PostgreSQL backend** that power the experience.

---

## ⚡ Quick Start for All Developers

### 🧩 Requirements

| Tool                         | macOS                                                                 | Windows                                                                                         |
| ---------------------------- | --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **Java 17+**                 | `brew install openjdk@17`                                             | [Download JDK 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html) |
| **Maven 3.9+**               | `brew install maven`                                                  | [Download Maven](https://maven.apache.org/download.cgi)                                         |
| **PostgreSQL 14+**           | `brew install postgresql`                                             | [PostgreSQL Installer](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)    |
| **Flutter SDK**              | [Install Flutter](https://flutter.dev/docs/get-started/install/macos) | [Install Flutter](https://flutter.dev/docs/get-started/install/windows)                         |
| **VS Code / Android Studio** | Any IDE with Java & Dart support                                      | Same                                                                                            |

---

## 🧱 Project Structure

```
Syncd-ARCP/
├── frontend/                     # Flutter frontend (mock-data-based)
│   ├── lib/
│   └── pubspec.yaml
│
├── backend/                      # Java Spring Boot backend
│   ├── src/
│   │   ├── main/java/com/syncd/syncd_backend/
│   │   │   ├── controller/     # AuthController
│   │   │   ├── service/        # UserService
│   │   │   ├── repository/     # UserRepository
│   │   │   ├── model/          # User entity
│   │   │   ├── config/         # SecurityConfig
│   │   │   └── SyncdBackendApplication.java
│   │   └── resources/
│   │       ├── application-example.yaml
│   │       └── application.yaml (local copy, ignored in git)
│   ├── pom.xml
│   └── target/
└── README.md
```

---

## ✅ Work Completed So Far

### 🧠 Backend (Developer A – Nehal Ajmal)

* Spring Boot project initialized with Maven
* PostgreSQL integration verified
* Database `syncd` created locally and connected successfully
* User authentication implemented and tested:

  * `POST /api/auth/register`
  * `POST /api/auth/login`
* Password encryption with **BCrypt**
* Application configuration converted to YAML (`application.yaml`)
* Build verified on **macOS** and **Windows**

### 🎨 Frontend (Developer C)

* Full Flutter UI built and functional
* Custom glassmorphism design + glitch splash screen
* Navigation and Provider-based state management working
* Currently uses **mock data** in `lib/services/` (no API calls yet)

### ⚙️ Environment Verified

* Backend runs successfully via `mvn spring-boot:run`
* Tomcat starts on port `8080`
* PostgreSQL connected without errors
* Endpoints tested in Postman (register + login ✅)

---

## 🗄️ Database Setup (Mac & Windows)

### 1️⃣ Create Database

```bash
psql -U postgres
CREATE DATABASE syncd;
\q
```

### 2️⃣ Configure Credentials

Copy example file and edit it:

```bash
cd backend/src/main/resources
cp application-example.yaml application.yaml
```

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/syncd
    username: postgres
    password: your_postgres_password
```

---

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

---

## 🧪 Test with Postman

### Register User

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

### Login User

```
POST http://localhost:8080/api/auth/login
Content-Type: application/json
```

```json
{
  "username": "nehal",
  "password": "test123"
}
```

Expected Response:
`User registered successfully!` or `Login successful!`

---

## 💡 Frontend Notes

* The Flutter app currently consumes mock data.
* All API services in `lib/services/` are ready for integration once more endpoints are added.
* No backend connection yet — backend verified independently.

---

## 🔧 Useful Commands

| Task             | macOS                            | Windows                                                 |
| ---------------- | -------------------------------- | ------------------------------------------------------- |
| Start PostgreSQL | `brew services start postgresql` | `pg_ctl -D "C:\Program Files\PostgreSQL\14\data" start` |
| Stop PostgreSQL  | `brew services stop postgresql`  | `pg_ctl stop`                                           |
| Access DB shell  | `psql -U postgres`               | `psql -U postgres`                                      |
| Build backend    | `mvn clean install`              | `mvn clean install`                                     |
| Run backend      | `mvn spring-boot:run`            | `mvn spring-boot:run`                                   |
| Run frontend     | `flutter run`                    | `flutter run`                                           |

---

## 🔄 Git Workflow

```bash
# clone
git clone https://github.com/<org>/Syncd-ARCP.git

# create feature branch
git checkout -b backend/auth-module

# commit changes
git add .
git commit -m "feat: added user auth module"

# push
git push origin backend/auth-module
```

---

## 👥 Team

| Name           | Role                         |
| -------------- | ---------------------------- |
| 🧠 Nehal Ajmal | Backend REST API & Database  |
| ⚡ Developer B  | WebSocket & Real-Time Engine |
| 🎨 Developer C | Flutter Frontend (UI & UX)   |

---

## 🧾 License

© 2025 **Sync’d Development Team** — All Rights Reserved.
Built collaboratively using **Spring Boot**, **PostgreSQL**, and **Flutter**.

---