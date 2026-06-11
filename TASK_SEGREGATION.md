# Swasthya App - Complete Task Segregation

**Date:** June 8, 2026
**Status:** All 36 screens built, now segregating tasks by dependency type

---

## LIST 1: Tasks Requiring API Integration (Needs You to Provide API Keys/Access)

### 1.1 Authentication & Social Login
- [ ] **Google Sign-In**
  - Need: Google OAuth 2.0 Client ID (from Google Cloud Console)
  - Need: Firebase project configuration
  - Need: SHA-1 certificate fingerprint for Android
  - Need: iOS URL scheme configuration
  
- [ ] **Apple Sign-In**
  - Need: Apple Developer account ($99/year)
  - Need: Service ID configuration in Apple Developer Portal
  - Need: iOS app bundle ID registration
  - Platform: iOS only (Android not supported by Apple)

- [ ] **SMS/OTP Service**
  - Need: Twilio Account SID and Auth Token OR
  - Need: MSG91 API key (Indian provider, cheaper)
  - Need: Sender ID registration (for Indian numbers)
  - Need: DLT registration (India TRAI compliance)

### 1.2 Maps & Location Services
- [ ] **Google Maps Platform**
  - Need: Google Maps API Key (from Google Cloud Console)
  - Need: Enable APIs: Maps SDK, Places API, Directions API, Geocoding API
  - Need: Billing account setup (free tier: $200/month credit)
  - Need: API key restrictions (Android/iOS apps)
  
- [ ] **Alternative: MapMyIndia** (Indian maps, more accurate for India)
  - Need: MapMyIndia API key
  - Need: REST API access for geocoding

### 1.3 Payment Gateway
- [ ] **Razorpay** (Recommended for India)
  - Need: Razorpay API Key ID and Secret
  - Need: Razorpay account (KYC required)
  - Need: Webhook endpoint for payment confirmations
  
- [ ] **Alternative: Stripe**
  - Need: Stripe Publishable and Secret keys
  - Need: Stripe account verification

### 1.4 Video Consultation
- [ ] **Agora.io**
  - Need: Agora App ID
  - Need: Agora Token (for secure channels)
  - Need: Enable video calling features
  
- [ ] **Alternative: Twilio Video**
  - Need: Twilio Account SID and Auth Token
  - Need: Twilio Video API key

### 1.5 Push Notifications
- [ ] **Firebase Cloud Messaging (FCM)**
  - Need: Firebase project setup
  - Need: google-services.json (Android)
  - Need: GoogleService-Info.plist (iOS)
  - Need: Server key for backend notifications

- [ ] **OneSignal** (Alternative)
  - Need: OneSignal App ID
  - Need: OneSignal REST API key

### 1.6 Cloud Storage & CDN
- [ ] **AWS S3** (for file storage - prescriptions, reports, images)
  - Need: AWS Access Key ID and Secret
  - Need: S3 bucket creation
  - Need: IAM permissions setup
  
- [ ] **Cloudinary** (for image optimization)
  - Need: Cloudinary Cloud Name, API Key, Secret

### 1.7 Analytics & Crash Reporting
- [ ] **Firebase Analytics**
  - Need: Firebase project (same as FCM)
  - Need: Analytics enabled
  
- [ ] **Sentry** (Error tracking)
  - Need: Sentry DSN (Data Source Name)
  - Need: Sentry project setup

### 1.8 SMS/Email Notifications
- [ ] **SendGrid/Amazon SES** (Email)
  - Need: API key for email service
  - Need: Verified sender domain
  
- [ ] **MSG91** (SMS - Indian)
  - Need: MSG91 Authkey
  - Need: DLT template registration

---

## LIST 2: Tasks Requiring Research & Resources from You

### 2.1 Medical Content & Databases
- [ ] **Disease Database Expansion**
  - Need: Comprehensive list of 500+ diseases with symptoms
  - Sources: WHO, CDC, ICMR (Indian Council of Medical Research)
  - Need: Indian-specific diseases (dengue, malaria, typhoid, TB, etc.)
  - Need: Symptom-to-disease mapping data
  - **Action Required:** Provide CSV/JSON files or API access to medical databases

- [ ] **Medicine Database Expansion**
  - Need: 10,000+ medicines with details
  - Sources: DrugBank, FDA Orange Book, CDSCO (India)
  - Need: Indian brand names (Crocin, Dolo, etc.)
  - Need: Generic names, manufacturers, prices
  - Need: Drug interaction data (50,000+ interactions)
  - **Action Required:** Provide medicine database CSV or API access

- [ ] **First Aid Content**
  - Need: 100+ first aid scenarios with detailed steps
  - Need: Video guides for each scenario (MP4 files or YouTube links)
  - Need: Audio instructions (MP3 files)
  - Need: Images/illustrations for each step
  - **Action Required:** Provide content files or source URLs

- [ ] **Health Articles**
  - Need: 500+ health articles in English
  - Need: Translations in 12 Indian languages
  - Need: Medical review/approval for accuracy
  - Topics: Nutrition, exercise, mental health, chronic diseases, women's health, child health
  - **Action Required:** Provide article content or CMS access

### 2.2 Doctor & Hospital Data
- [ ] **Real Doctor Database**
  - Need: List of real doctors with credentials
  - Need: Medical license numbers (MCI/NMC registration)
  - Need: Specialties, experience, fees, languages
  - Need: Clinic/hospital addresses with coordinates
  - Need: Availability schedules
  - **Action Required:** Partner with hospitals/clinics OR provide doctor database

- [ ] **Hospital Directory**
  - Need: Hospital names, addresses, contact info
  - Need: Bed capacity, specialties, emergency services
  - Need: Real-time bed availability (if available)
  - Need: Blood bank information
  - **Action Required:** Provide hospital data or API access

- [ ] **Doctor Verification System**
  - Need: Process to verify medical credentials
  - Need: MCI/NMC registration number validation API
  - Need: Background check procedures
  - **Action Required:** Define verification workflow and legal requirements

### 2.3 Legal & Compliance
- [ ] **DPDP Act 2023 Compliance**
  - Need: Legal review of data processing practices
  - Need: Consent forms and privacy policy
  - Need: Data Processing Agreement (DPA)
  - **Action Required:** Consult with legal team/lawyer

- [ ] **Telemedicine Guidelines 2020**
  - Need: Compliance with Indian telemedicine regulations
  - Need: Prescription validity rules
  - Need: Doctor-patient consultation records
  - **Action Required:** Legal review and policy drafting

- [ ] **E-Pharmacy Rules**
  - Need: Prescription validation requirements
  - Need: Schedule X drug restrictions
  - Need: Pharmacy license verification
  - **Action Required:** Partner with licensed pharmacies

### 2.4 Language & Localization
- [ ] **Medical Translation**
  - Need: Professional medical translators for 12 languages
  - Need: Medical terminology dictionaries
  - Need: Quality assurance for translations
  - Languages: Hindi, Kannada, Tamil, Telugu, Malayalam, Marathi, Bengali, Gujarati, Punjabi, Odia, Urdu
  - **Action Required:** Hire translators or provide translation budget

- [ ] **Voice/TTS in Regional Languages**
  - Need: Text-to-speech engines for Indian languages
  - Sources: Google TTS, AI4Bharat Indic-TTS, AWS Polly
  - **Action Required:** Evaluate and select TTS provider

### 2.5 Content Moderation
- [ ] **Health Content Review**
  - Need: Medical advisory board (doctors to review content)
  - Need: Fact-checking process
  - Need: Content update schedule (medical info changes)
  - **Action Required:** Recruit medical advisors

---

## LIST 3: Tasks I Can Do Right Now (No External Dependencies)

### 3.1 Database Initialization & Schema Design
- [ ] **PostgreSQL Schema Design**
  - [ ] Users table (auth, profile, preferences)
  - [ ] Doctors table (profile, credentials, availability)
  - [ ] Hospitals table (details, services, location)
  - [ ] Appointments table (booking, status, history)
  - [ ] Health records table (documents, metadata)
  - [ ] Medicines table (details, pricing, stock)
  - [ ] Prescriptions table (medicines, dosage, duration)
  - [ ] Symptom checks table (symptoms, predicted diseases, confidence)
  - [ ] Family members table (linked to user)
  - [ ] Health metrics table (BP, sugar, weight, etc.)
  - [ ] Medication reminders table (schedule, adherence)
  - [ ] Articles table (content, category, tags)
  - [ ] First aid scenarios table (steps, media)
  - [ ] Emergency contacts table (numbers, categories)
  - [ ] Activity logs table (audit trail)

- [ ] **MongoDB Collections**
  - [ ] Health documents (prescriptions, lab reports, images)
  - [ ] Chat/consultation transcripts
  - [ ] User activity logs
  - [ ] Unstructured medical data

- [ ] **Redis Cache Design**
  - [ ] Session store (JWT tokens)
  - [ ] OTP cache (5-minute expiry)
  - [ ] Search results cache
  - [ ] Doctor availability cache
  - [ ] Medicine search cache

- [ ] **SQLite/Hive Local Schema**
  - [ ] Offline first aid scenarios
  - [ ] Offline medicine database (top 5000)
  - [ ] Offline health articles (top 100)
  - [ ] Offline emergency contacts
  - [ ] User health records (sync queue)
  - [ ] Medication reminders (local schedule)

### 3.2 Backend API Development (NestJS)
- [ ] **Auth Service**
  - [ ] Register endpoint (email/password)
  - [ ] Login endpoint (JWT token generation)
  - [ ] OTP generation and verification
  - [ ] Password reset flow
  - [ ] Token refresh mechanism
  - [ ] Social login handlers (Google, Apple)
  - [ ] Biometric auth support
  - [ ] Rate limiting (5 attempts per 15 min)

- [ ] **User Service**
  - [ ] Profile CRUD operations
  - [ ] Family member management (add, edit, delete)
  - [ ] Health profile management
  - [ ] Preference settings (language, theme, notifications)
  - [ ] Data export (GDPR/DPDP compliance)
  - [ ] Account deletion (right to be forgotten)

- [ ] **Doctor Service**
  - [ ] Doctor registration and verification
  - [ ] Profile management
  - [ ] Availability schedule management
  - [ ] Search and filter API
  - [ ] Rating and review system
  - [ ] Consultation history

- [ ] **Appointment Service**
  - [ ] Booking creation and validation
  - [ ] Real-time availability checking
  - [ ] Appointment status management
  - [ ] Reminder scheduling
  - [ ] Cancellation and rescheduling
  - [ ] Video consultation link generation

- [ ] **Health Records Service**
  - [ ] Document upload (prescriptions, reports)
  - [ ] OCR for text extraction
  - [ ] Document categorization
  - [ ] Secure storage with encryption
  - [ ] Share with doctor (temporary access)
  - [ ] Version history

- [ ] **Medicine Service**
  - [ ] Medicine search API
  - [ ] Drug interaction checker
  - [ ] Pill identifier (image recognition)
  - [ ] Medicine details and alternatives
  - [ ] Price comparison
  - [ ] Stock availability

- [ ] **Symptom Checker Service**
  - [ ] Symptom input API
  - [ ] Disease prediction (ML model integration)
  - [ ] Follow-up question generation
  - [ ] Confidence scoring
  - [ ] "When to see doctor" recommendations

- [ ] **Notification Service**
  - [ ] Push notification scheduling
  - [ ] Email notification templates
  - [ ] SMS notification (via Twilio/MSG91)
  - [ ] Notification preferences management
  - [ ] Delivery status tracking

### 3.3 Flutter App Enhancements (No API Needed)
- [ ] **Family Member Management Enhancement**
  - [ ] Add family member with full details (name, age, gender, blood group, allergies, conditions, medications)
  - [ ] Edit family member details
  - [ ] Delete family member with confirmation
  - [ ] Link family member to health records
  - [ ] Separate health tracker for each family member
  - [ ] Share family member data with doctor (consent-based)

- [ ] **Health Trackers Enhancement**
  - [ ] Blood Pressure tracker with chart (systolic/diastolic/pulse)
  - [ ] Blood Sugar tracker (fasting/post-meal/random) with trends
  - [ ] Weight tracker with BMI calculation and goal setting
  - [ ] Temperature tracker with fever detection
  - [ ] Heart Rate tracker with abnormal rhythm alerts
  - [ ] SpO2 tracker (oxygen saturation)
  - [ ] Export data as PDF/CSV
  - [ ] Share with doctor
  - [ ] Set normal ranges and get alerts

- [ ] **Drug Interaction Enhancement**
  - [ ] Expand mock database to 100+ drugs
  - [ ] Add more interaction types (food, alcohol, disease)
  - [ ] Severity levels with color coding
  - [ ] Detailed interaction descriptions
  - [ ] Management recommendations
  - [ ] Save interaction checks to history

- [ ] **My Profile Enhancement**
  - [ ] Edit all personal details (name, age, gender, blood group, height, weight)
  - [ ] Add/edit medical conditions (diabetes, hypertension, etc.)
  - [ ] Add/edit allergies (medicine, food, environmental)
  - [ ] Add/edit current medications with dosage
  - [ ] Add/edit emergency contacts
  - [ ] Upload profile picture
  - [ ] Change password
  - [ ] Manage linked accounts (Google/Apple)
  - [ ] Data export (download all my data)
  - [ ] Account deletion

- [ ] **Language System Enhancement**
  - [ ] Complete translation framework setup
  - [ ] ARB files for all 12 languages
  - [ ] Fallback to English if translation missing
  - [ ] RTL support for Urdu
  - [ ] Font loading for all scripts
  - [ ] Language-specific formatting (dates, numbers)

- [ ] **Offline Mode Enhancement**
  - [ ] Download all first aid content on install
  - [ ] Download top 5000 medicines
  - [ ] Download top 100 health articles
  - [ ] Download emergency contacts
  - [ ] Sync queue for when online
  - [ ] Conflict resolution (server vs local)
  - [ ] Storage management (auto-delete old cache)

- [ ] **Medication Reminders Enhancement**
  - [ ] Schedule multiple reminders per day
  - [ ] Custom reminder tones
  - [ ] Snooze options (10 min, 30 min, 1 hour)
  - [ ] Mark as taken/skipped from notification
  - [ ] Adherence tracking and reporting
  - [ ] Refill reminders (when running low)
  - [ ] Missed dose alerts
  - [ ] Background execution (Android WorkManager, iOS Background Fetch)

- [ ] **Health Calculators Enhancement**
  - [ ] BMI with Indian standards (underweight <18.5, normal 18.5-22.9, overweight 23-24.9, obese ≥25)
  - [ ] BMR with multiple formulas (Harris-Benedict, Mifflin-St Jeor)
  - [ ] TDEE with activity levels
  - [ ] Pregnancy due date calculator (LMP or conception date)
  - [ ] Ovulation tracker (fertile window prediction)
  - [ ] Vaccine schedule (IAP recommended schedule for children)
  - [ ] Calorie burn calculator by activity
  - [ ] Water intake calculator
  - [ ] Sleep cycle calculator

- [ ] **Health Articles Enhancement**
  - [ ] Search and filter by category
  - [ ] Bookmark for offline reading
  - [ ] Share via WhatsApp, email, social media
  - [ ] Reading time estimation
  - [ ] Related articles suggestions
  - [ ] Like and comment system
  - [ ] Text-to-speech for articles

- [ ] **First Aid Enhancement**
  - [ ] Add 100+ scenarios (currently 10)
  - [ ] Step-by-step with images
  - [ ] Video guides integration (placeholder for now)
  - [ ] Audio instructions (placeholder for now)
  - [ ] Emergency call button (108)
  - [ ] Share location with emergency contacts
  - [ ] Works completely offline

- [ ] **Emergency SOS Enhancement**
  - [ ] One-tap emergency call (108)
  - [ ] Share location with emergency contacts
  - [ ] Send SOS message to family members
  - [ ] Flashlight SOS signal
  - [ ] Loud alarm sound
  - [ ] Offline emergency contacts (always available)

- [ ] **UI/UX Enhancements**
  - [ ] Smooth animations and transitions
  - [ ] Skeleton loaders for loading states
  - [ ] Error states with retry buttons
  - [ ] Empty states with illustrations
  - [ ] Pull-to-refresh on all lists
  - [ ] Infinite scroll for long lists
  - [ ] Search debouncing (300ms)
  - [ ] Image caching and optimization
  - [ ] Responsive design for tablets

### 3.4 Testing & Quality Assurance
- [ ] **Unit Tests**
  - [ ] Test all providers (auth, theme, locale, cart)
  - [ ] Test all models (serialization/deserialization)
  - [ ] Test utility functions (validators, formatters)
  - [ ] Test calculator logic (BMI, BMR, etc.)
  - [ ] Mock API responses for testing

- [ ] **Widget Tests**
  - [ ] Test all screen widgets
  - [ ] Test navigation flows
  - [ ] Test form validation
  - [ ] Test button interactions
  - [ ] Test list scrolling

- [ ] **Integration Tests**
  - [ ] End-to-end user flows
  - [ ] Login → Home → Feature → Back
  - [ ] Offline/online sync testing
  - [ ] Deep linking tests

### 3.5 Documentation
- [ ] **API Documentation**
  - [ ] Swagger/OpenAPI spec for all endpoints
  - [ ] Request/response examples
  - [ ] Error code documentation
  - [ ] Authentication guide

- [ ] **App Documentation**
  - [ ] User guide (how to use each feature)
  - [ ] FAQ section
  - [ ] Troubleshooting guide
  - [ ] Privacy policy
  - [ ] Terms of service
  - [ ] Medical disclaimer

- [ ] **Developer Documentation**
  - [ ] Setup guide for new developers
  - [ ] Architecture diagrams
  - [ ] Database schema documentation
  - [ ] Deployment guide
  - [ ] Contributing guidelines

---

## Summary

| List | Count | Status | Next Action |
|------|-------|--------|-------------|
| **List 1: API Integration** | 8 major APIs | 🔴 Blocked | You provide API keys |
| **List 2: Research/Resources** | 5 major areas | 🟡 Waiting | You provide data/content |
| **List 3: I Can Do Now** | 15 major tasks | 🟢 Ready | I start immediately |

---

## Recommended Starting Order

### Week 1 (List 3 - Independent)
1. Database schema design (PostgreSQL, MongoDB, Redis, SQLite)
2. Backend API development (NestJS - Auth, User, Doctor services)
3. Family member management enhancement
4. Health trackers enhancement
5. My Profile enhancement

### Week 2 (List 3 + List 2)
6. Drug interaction enhancement (mock data expansion)
7. Health calculators enhancement
8. First aid enhancement (mock data expansion)
9. Start content creation/research for List 2

### Week 3 (List 1 + List 2)
10. Integrate APIs as you provide keys
11. Continue content development
12. Testing and QA

### Week 4
13. Deployment preparation
14. Final testing
15. Launch

---

## What I Need from You to Start

### To Start List 3 (Immediate):
- ✅ Nothing! I can start right now

### To Start List 1 (API Integration):
- Google Maps API Key
- Firebase project setup (for auth, notifications, analytics)
- Twilio/MSG91 account (for SMS)
- Razorpay/Stripe account (for payments)
- Agora account (for video calls)
- AWS account (for file storage)
- Sentry account (for error tracking)

### To Start List 2 (Research/Resources):
- Medical content (diseases, medicines, first aid)
- Doctor/hospital data OR partnership contacts
- Translation budget or translator contacts
- Legal advisor for compliance
- Medical advisory board contacts

---

*Created: June 8, 2026*
*Ready to start List 3 immediately!*
