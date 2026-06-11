# Swasthya App - Database Inventory

## Overview
All data is stored in **Dart files as in-memory lists/maps** (mock data for development). Production will use:
- **Backend APIs** (NestJS microservices)
- **SQLite/Hive** (local offline storage)
- **PostgreSQL/MongoDB** (server databases)

---

## Phase 1: Foundation (Splash, Onboarding, Login)

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `onboarding_screen.dart` | Onboarding pages (images, titles, descriptions) | Inline in file | 3 pages |
| `login_screen.dart` | Login form fields | Inline in file | - |

---

## Phase 2: Core Backend (API Services)

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `services/auth_service.dart` | Auth API endpoints | Backend (NestJS) | - |

---

## Phase 3: Home Screen

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `home_screen.dart` | Feature grid items | `_features` list (line ~48) | 14 features |
| `home_screen.dart` | Quick actions | `_quickActions` list | 4 actions |
| `home_screen.dart` | Health tips carousel | `_healthTips` list | 5 tips |

---

## Phase 4: Symptom Checker

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `symptom_checker_screen.dart` | Body parts list | `_bodyParts` list | 12 parts |
| `symptom_checker_screen.dart` | Symptoms database | `_symptomsDatabase` map | 50+ symptoms |
| `symptom_checker_screen.dart` | Conditions database | `_conditionsDatabase` map | 20+ conditions |

---

## Phase 5: Medicine & Pharmacy

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `medicine_search_screen.dart` | Trending medicines | `_trendingMedicines` list | 5 items |
| `medicine_search_screen.dart` | Categories | `_categories` list | 6 categories |
| `medicine_search_screen.dart` | Mock medicines | `_mockMedicines` list | 10 medicines |
| `medicine_detail_screen.dart` | Medicine details | Passed via navigation | - |
| `cart_provider.dart` | Cart items | Provider state | Dynamic |
| `order_history_screen.dart` | Mock orders | `_mockOrders` list | 3 orders |
| `prescription_upload_screen.dart` | Prescription types | `_prescriptionTypes` list | 3 types |
| `barcode_scanner_screen.dart` | Mock barcode results | `_mockBarcodes` map | 5 barcodes |

---

## Phase 6: Doctor Directory

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `doctor_directory_screen.dart` | Mock doctors | `_doctors` list | 10 doctors |
| `doctor_directory_screen.dart` | Specialties | `_specialties` list | 10 specialties |
| `doctor_booking_screen.dart` | Time slots | Generated dynamically | - |
| `video_consultation_screen.dart` | Mock upcoming calls | `_upcomingCalls` list | 2 calls |

---

## Phase 7: Health Records

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `health_records_screen.dart` | Mock records | `_records` list | 5 records |
| `medication_reminders_screen.dart` | Mock medications | `_medications` list | 4 medications |
| `profile_screen.dart` | User profile | Static data | 1 user |
| `settings_screen.dart` | Settings options | Inline in file | - |

---

## Phase 8: Emergency & First Aid

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `first_aid_screen.dart` | First aid scenarios | `_firstAidScenarios` list | 10 scenarios |
| `emergency_sos_screen.dart` | Emergency contacts | `_emergencyContacts` list | 12 contacts |
| `emergency_sos_screen.dart` | Blood banks | `_bloodBanks` list | 5 banks |
| `emergency_sos_screen.dart` | Nearby hospitals | `_nearbyHospitals` list | 5 hospitals |

---

## Phase 9: Health Content (Articles, Calculators, Tips)

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `health_articles_screen.dart` | Trending articles | `_trendingArticles` list | 5 articles |
| `health_articles_screen.dart` | Categories | `_categories` list | 11 categories |
| `health_articles_screen.dart` | All articles | `_allArticles` list | 15 articles |
| `article_detail_screen.dart` | Article content | Passed via navigation | - |
| `health_calculators_screen.dart` | Calculator types | `_calculatorTypes` list | 5 calculators |
| `health_calculators_screen.dart` | BMI categories | Inline in BMI section | Indian standards |
| `health_calculators_screen.dart` | BMR activity levels | `_activityLevels` list | 5 levels |
| `health_calculators_screen.dart` | Vaccine schedule | `_vaccineSchedule` list | 14 vaccines |
| `health_tips_screen.dart` | Daily tips | `_dailyTips` list | 10 tips |
| `health_tips_screen.dart` | Categories | `_categories` list | 6 categories |

---

## Phase 10: Health Trackers

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `health_trackers_screen.dart` | Tracker types | `_trackerTypes` list | 5 trackers |
| `health_trackers_screen.dart` | BP readings | `_bpReadings` list | 3 readings |
| `health_trackers_screen.dart` | Sugar readings | `_sugarReadings` list | 3 readings |
| `health_trackers_screen.dart` | Weight readings | `_weightReadings` list | 3 readings |
| `health_trackers_screen.dart` | Temperature readings | `_tempReadings` list | 3 readings |
| `health_trackers_screen.dart` | Heart rate readings | `_hrReadings` list | 3 readings |

---

## Phase 11: Pill Identifier & Drug Interactions

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `pill_identifier_screen.dart` | Pill colors | `_pillColors` list | 11 colors |
| `pill_identifier_screen.dart` | Pill shapes | `_pillShapes` list | 9 shapes |
| `pill_identifier_screen.dart` | Pill sizes | `_pillSizes` list | 4 sizes |
| `pill_identifier_screen.dart` | Mock results | `_mockResults` list | 3 results |
| `drug_interaction_screen.dart` | Mock drug database | `_mockDrugDatabase` list | 15 drugs |
| `drug_interaction_screen.dart` | Interaction rules | `_interactionRules` map | 5 rules |

---

## Phase 12: Family Members

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `family_members_screen.dart` | Family members | `_familyMembers` list | 3 members |

---

## Phase 13: Offline Mode (NEW)

| File | Data Type | Location | Size |
|------|-----------|----------|------|
| `services/offline_manager.dart` | First aid scenarios | `_getFallbackFirstAid()` method | 10 scenarios |
| `services/offline_manager.dart` | Emergency contacts | `_getDefaultEmergencyContacts()` method | 12 contacts |
| `services/offline_manager.dart` | Medicines | `_getFallbackMedicines()` method | 10 medicines |
| `services/offline_manager.dart` | Health tips | `_getFallbackHealthTips()` method | 5 tips |
| `screens/offline_first_aid_screen.dart` | Same as above | Uses OfflineManager | - |
| `screens/offline_medicine_screen.dart` | Same as above | Uses OfflineManager | - |
| `screens/offline_emergency_screen.dart` | Same as above | Uses OfflineManager | - |

---

## Assets Folder (Images, Icons, Animations)

```
assets/
├── images/
│   ├── splash_logo.png
│   ├── onboarding_1.png
│   ├── onboarding_2.png
│   ├── onboarding_3.png
│   └── ... (other images)
├── icons/
│   ├── app_icon.png
│   └── app_icon_foreground.png
├── animations/
│   └── ... (Lottie animations)
└── data/ (JSON files for offline data - OPTIONAL)
    ├── first_aid_scenarios.json
    ├── offline_medicines.json
    └── emergency_contacts.json
```

---

## Hive Local Storage (Runtime)

Stored on device at runtime (not in repo):

```
Hive boxes (stored in app documents directory):
├── first_aid_offline
├── medicine_offline
├── emergency_offline
├── health_tips_offline
├── sync_queue
└── offline_metadata
```

---

## Summary of All Data Locations

| Storage Type | Location | Count | Purpose |
|-------------|----------|-------|---------|
| **Inline Dart Lists** | Screen files | 50+ lists | Mock data for UI development |
| **Hive Boxes** | Device storage (runtime) | 6 boxes | Offline cache, sync queue |
| **Asset JSON** | `assets/data/` folder | 3 files | Optional pre-loaded data |
| **Backend APIs** | NestJS microservices | 5 services | Production data source |
| **SharedPreferences** | Device storage | Key-value | Settings, auth tokens |

---

## How to Update Data

### Option 1: Share Files with Me
- Send CSV, JSON, or Excel files
- I'll convert to Dart lists and update the screen files

### Option 2: Update Inline Data (Quick)
- Edit the `_mock*` or `_data*` lists directly in screen files
- Rebuild the app

### Option 3: Add Asset JSON Files
- Add JSON files to `assets/data/` folder
- Update `pubspec.yaml` to include them
- Load using `rootBundle.loadString()`

### Option 4: Admin Panel (Future)
- Upload via React admin panel
- Backend API stores in PostgreSQL
- Flutter app syncs via API

---

*Total Mock Data Items: ~200+ items across all screens*
*Last Updated: 2026-06-08*
