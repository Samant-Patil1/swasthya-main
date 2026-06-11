# Swasthya - Health App for India 🇮🇳

**Swasthya** (स्वास्थ्य) is an open-source health & wellness platform built for India. It includes a Flutter mobile app, 5 backend microservices, an admin panel, an ML-powered symptom checker, and a comprehensive offline medicine & disease database sourced from real Indian medical data.

---

## 📁 Repository Structure

This is the **main repository** that connects all Swasthya components. Each component is either a submodule or a sub-directory within this repo.

```
swasthya-main/
├── mobile/                 ← Flutter mobile app (submodule → swasthya-mobile)
├── api/                    ← Backend microservices (5 NestJS services)
│   ├── services/
│   │   ├── auth-service/          # Authentication & OTP
│   │   ├── doctor-service/      # Doctor search & profiles
│   │   ├── emergency-service/   # First aid & emergency contacts
│   │   ├── health-records-service/ # Patient records & prescriptions
│   │   └── medicine-service/    # Medicine search & drug interactions
│   ├── api-gateway/        # API Gateway (single entry point)
│   └── src/                # Shared code & utilities
├── admin/                  ← React admin panel (Vite + Tailwind)
├── database/             ← SQL schema & seed data
├── ml/                   ← Python ML service (symptom checker)
├── docs-push/            # Documentation & design assets
└── README.md             # You are here!
```

---

## 🚀 Quick Start (Run Everything Locally)

### Prerequisites

| Tool | Version | Install Link |
|------|---------|-------------|
| Node.js | ≥18 | [nodejs.org](https://nodejs.org/) |
| Flutter | ≥3.27 | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Python | ≥3.10 | [python.org](https://python.org) |
| PostgreSQL | ≥15 | [postgresql.org](https://postgresql.org) |
| Git | ≥2.40 | [git-scm.com](https://git-scm.com) |

---

## 1️⃣ Clone the Main Repo (with all submodules)

```bash
git clone --recursive https://github.com/swasthya-health1/swasthya-main.git
cd swasthya-main
```

If you already cloned without `--recursive`:
```bash
git submodule update --init --recursive
```

---

## 2️⃣ Database Setup

```bash
# Install PostgreSQL (macOS)
brew install postgresql@15
brew services start postgresql@15

# Create database
createdb swasthya_db

# Run schema
psql swasthya_db < database/schema.sql
```

**Connection string:** `postgresql://localhost:5432/swasthya_db`

---

## 3️⃣ Backend API (5 Microservices)

```bash
cd api

# Install dependencies
npm install

# Create environment file
cp .env.example .env
# Edit .env with your DB credentials

# Start all services (uses pm2 or concurrently)
npm run dev:all

# Or start individually:
npm run dev:auth        # Port 3001
npm run dev:medicine    # Port 3002
npm run dev:doctor      # Port 3003
npm run dev:emergency   # Port 3004
npm run dev:records     # Port 3005

# API Gateway (single entry point)
npm run dev:gateway     # Port 3000
```

**API Documentation:** Once running, visit `http://localhost:3000/api/docs`

---

## 4️⃣ ML Service (Symptom Checker)

```bash
cd ml

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the ML service
python main.py
```

The ML service runs on **port 8000** by default.

---

## 5️⃣ Admin Panel

```bash
cd admin

# Install dependencies
npm install

# Start dev server
npm run dev
```

The admin panel runs on **port 5173** by default.

---

## 6️⃣ Mobile App (Flutter)

```bash
cd mobile

# Install Flutter dependencies
flutter pub get

# Run on iOS Simulator
flutter run -d ios

# Run on Android Emulator
flutter run -d android

# Run on Chrome (for web testing)
flutter run -d chrome

# Build APK (Android)
flutter build apk --release

# Build iOS (requires macOS + Xcode)
flutter build ios --release
```

### Mobile App Features
- 🔍 **Medicine Search** – 4,453+ medicines with prices, categories, side effects
- 🏥 **Disease Database** – 396 diseases with symptoms, treatments, precautions
- 🩺 **Symptom Checker** – ML-powered with 1,143+ searchable symptoms
- 🚨 **Emergency SOS** – One-tap emergency contacts & first aid
- 💊 **Drug Interaction** – Check dangerous drug combinations
- 📊 **Health Trackers** – Blood pressure, blood sugar, weight, BMI
- 🔧 **Offline Mode** – Works without internet (200 medicines cached)
- 🇮🇳 **Bilingual** – English + Hindi support

---

## 🧪 Testing

### Backend APIs
```bash
cd api
npm run test          # Unit tests
npm run test:e2e      # End-to-end tests
```

### Mobile App
```bash
cd mobile
flutter test
```

### ML Service
```bash
cd ml
python -m pytest
```

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                    Flutter Mobile App                  │
│  (Android, iOS, Web)                                 │
│  - Offline mode with SQLite/Hive                     │
│  - REST API calls to Gateway                         │
└──────────────────┬────────────────────────────────────┘
                   │ HTTP/HTTPS
                   ▼
┌─────────────────────────────────────────────────────┐
│                  API Gateway (Port 3000)              │
│  - Rate limiting, Auth, Routing                      │
└──────────────────┬────────────────────────────────────┘
                   │
        ┌──────────┼──────────┬──────────┬──────────┐
        ▼          ▼          ▼          ▼          ▼
  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
  │ Auth   │ │Doctor  │ │Emerg.  │ │Health  │ │Medicine│
  │Service │ │Service │ │Service │ │Records │ │Service │
  │:3001   │ │:3003   │ │:3004   │ │:3005   │ │:3002   │
  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘
        │          │          │          │          │
        └──────────┴──────────┴──────────┴──────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │  PostgreSQL DB    │
                    │  (swasthya_db)   │
                    └─────────────────┘
                             │
        ┌────────────────────┼────────────────────┐
        ▼                    ▼                    ▼
  ┌──────────┐      ┌──────────────┐      ┌──────────┐
  │  ML API  │      │  Admin Panel │      │  Kaggle  │
  │  :8000   │      │  :5173       │      │  Datasets│
  │(Symptom  │      │  (React)     │      │(7 sets) │
  │ Checker) │      │              │      │          │
  └──────────┘      └──────────────┘      └──────────┘
```

---

## 📦 Data Sources

Medicine & disease data sourced from Kaggle:

| Dataset | Records | Usage |
|---------|---------|-------|
| Disease & Symptoms | 400 diseases | Disease database |
| A-Z Medicine (India) | 25,000+ medicines | Medicine catalog |
| Indian Medicine Data | 19,000+ medicines | Medicine descriptions |
| Extensive A-Z Medicines | 25,000+ medicines | Side effects, substitutes |
| India Drug Info | 34,000+ medicines | Prices, prescriptions |
| Symptom-to-Disease | 492 diseases, 200 symptoms | ML training |
| Disease & Symptoms (v2) | 41 diseases + precautions | Precautions data |

---

## 📝 Environment Variables

Create `.env` files in the following locations:

### `api/.env`
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=swasthya_db
DB_USER=postgres
DB_PASSWORD=yourpassword
JWT_SECRET=your-secret-key

AUTH_PORT=3001
MEDICINE_PORT=3002
DOCTOR_PORT=3003
EMERGENCY_PORT=3004
RECORDS_PORT=3005
GATEWAY_PORT=3000
```

### `mobile/.env` (optional)
```
API_BASE_URL=http://localhost:3000
ML_API_URL=http://localhost:8000
```

### `admin/.env`
```
VITE_API_URL=http://localhost:3000
```

---

## 🛠️ Development Commands

| Command | Description |
|---------|-------------|
| `npm run dev:all` | Start all backend services |
| `flutter run` | Start mobile app |
| `python main.py` | Start ML service |
| `npm run dev` | Start admin panel |
| `npm run build` | Build production backend |
| `flutter build apk` | Build Android APK |
| `flutter build ios` | Build iOS app |

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 👥 Team

Built by **Samant Patil** and the Swasthya community.

---

## 🆘 Support

- Open an [Issue](https://github.com/swasthya-health1/swasthya-main/issues)
- Join our [Discord](https://discord.gg/swasthya) (coming soon)
- Email: swasthya@health1.org

---

_स्वास्थ्य ही धन है - Health is Wealth 🙏_
