-- Swasthya Database Schema
-- PostgreSQL + MongoDB + Redis + SQLite
-- Created: June 8, 2026

-- ============================================================
-- POSTGRESQL SCHEMA (Primary Relational Database)
-- ============================================================

-- Users Table (Authentication & Profile)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255), -- NULL for social login users
    phone VARCHAR(20) UNIQUE,
    is_phone_verified BOOLEAN DEFAULT FALSE,
    is_email_verified BOOLEAN DEFAULT FALSE,
    auth_provider VARCHAR(20) DEFAULT 'email', -- email, google, apple
    auth_provider_id VARCHAR(255), -- Google/Apple user ID
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP WITH TIME ZONE,
    
    -- Profile fields
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(10), -- male, female, other
    blood_group VARCHAR(5), -- A+, B-, O+, etc.
    height_cm INTEGER,
    weight_kg DECIMAL(5,2),
    
    -- Medical profile
    allergies TEXT[], -- Array of allergies
    chronic_conditions TEXT[], -- Array of conditions
    current_medications JSONB, -- [{name, dosage, frequency}]
    
    -- Emergency contacts
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    emergency_contact_relation VARCHAR(50),
    
    -- Preferences
    preferred_language VARCHAR(10) DEFAULT 'en',
    theme_mode VARCHAR(20) DEFAULT 'light',
    notification_enabled BOOLEAN DEFAULT TRUE,
    
    -- Security
    biometric_enabled BOOLEAN DEFAULT FALSE,
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    
    -- Audit
    created_by_ip INET,
    last_login_ip INET
);

-- Family Members Table
CREATE TABLE family_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    relationship VARCHAR(50) NOT NULL, -- spouse, child, parent, sibling, other
    date_of_birth DATE,
    gender VARCHAR(10),
    blood_group VARCHAR(5),
    height_cm INTEGER,
    weight_kg DECIMAL(5,2),
    allergies TEXT[],
    chronic_conditions TEXT[],
    current_medications JSONB,
    is_primary BOOLEAN DEFAULT FALSE, -- Is this the primary user themselves?
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, first_name, relationship) -- Prevent duplicates
);

-- Doctors Table
CREATE TABLE doctors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    is_verified BOOLEAN DEFAULT FALSE,
    
    -- Profile
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    profile_image_url TEXT,
    qualifications TEXT[], -- ["MBBS", "MD", "DNB"]
    specialties TEXT[], -- ["Cardiology", "General Medicine"]
    years_of_experience INTEGER,
    languages_spoken TEXT[], -- ["English", "Hindi", "Kannada"]
    
    -- Medical Council Registration
    medical_council VARCHAR(100), -- MCI, NMC, State Council
    registration_number VARCHAR(50) UNIQUE,
    registration_year INTEGER,
    
    -- Practice Details
    consultation_fee DECIMAL(10,2),
    follow_up_fee DECIMAL(10,2),
    video_consultation_fee DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'INR',
    
    -- Availability
    is_available_for_consultation BOOLEAN DEFAULT TRUE,
    consultation_duration_minutes INTEGER DEFAULT 15,
    
    -- Ratings
    average_rating DECIMAL(2,1) DEFAULT 0.0,
    total_reviews INTEGER DEFAULT 0,
    
    -- Location
    clinic_address TEXT,
    clinic_city VARCHAR(100),
    clinic_state VARCHAR(100),
    clinic_pincode VARCHAR(10),
    clinic_latitude DECIMAL(10,8),
    clinic_longitude DECIMAL(11,8),
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT TRUE
);

-- Doctor Availability Schedule
CREATE TABLE doctor_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Sunday
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    slot_duration_minutes INTEGER DEFAULT 15,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(doctor_id, day_of_week, start_time)
);

-- Appointments Table
CREATE TABLE appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    doctor_id UUID NOT NULL REFERENCES doctors(id),
    family_member_id UUID REFERENCES family_members(id), -- NULL if for user themselves
    
    -- Appointment Details
    appointment_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(20) DEFAULT 'scheduled', -- scheduled, confirmed, completed, cancelled, no_show
    type VARCHAR(20) DEFAULT 'in_person', -- in_person, video, phone
    
    -- Reason & Notes
    reason_for_visit TEXT,
    symptoms TEXT[],
    notes TEXT,
    doctor_notes TEXT,
    
    -- Video Consultation (if applicable)
    video_call_link TEXT,
    video_call_provider VARCHAR(20), -- agora, twilio
    
    -- Payment
    fee DECIMAL(10,2),
    payment_status VARCHAR(20) DEFAULT 'pending', -- pending, paid, refunded, failed
    payment_method VARCHAR(20),
    
    -- Reminders
    reminder_sent_24h BOOLEAN DEFAULT FALSE,
    reminder_sent_1h BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cancelled_at TIMESTAMP WITH TIME ZONE,
    cancellation_reason TEXT,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Health Records Table
CREATE TABLE health_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    family_member_id UUID REFERENCES family_members(id),
    
    -- Record Details
    record_type VARCHAR(50) NOT NULL, -- prescription, lab_report, discharge_summary, imaging, vaccination, other
    title VARCHAR(255) NOT NULL,
    description TEXT,
    
    -- File Storage (MongoDB reference)
    file_id VARCHAR(255), -- MongoDB GridFS file ID
    file_name VARCHAR(255),
    file_size_bytes INTEGER,
    file_mime_type VARCHAR(100),
    file_url TEXT, -- CDN URL
    
    -- OCR Data
    ocr_text TEXT, -- Extracted text from image/PDF
    ocr_confidence DECIMAL(5,2),
    
    -- Doctor/Clinic Info
    doctor_name VARCHAR(255),
    clinic_name VARCHAR(255),
    clinic_address TEXT,
    
    -- Dates
    record_date DATE NOT NULL,
    follow_up_date DATE,
    
    -- Metadata
    tags TEXT[],
    is_favorite BOOLEAN DEFAULT FALSE,
    is_shared BOOLEAN DEFAULT FALSE,
    shared_with_doctor_id UUID REFERENCES doctors(id),
    share_expires_at TIMESTAMP WITH TIME ZONE,
    
    -- Audit
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    uploaded_by_ip INET
);

-- Health Metrics (Trackers) Table
CREATE TABLE health_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    family_member_id UUID REFERENCES family_members(id),
    
    -- Metric Type
    metric_type VARCHAR(50) NOT NULL, -- blood_pressure, blood_sugar, weight, temperature, heart_rate, spo2, bmi
    
    -- Values (JSONB for flexibility)
    values JSONB NOT NULL,
    -- Examples:
    -- BP: {"systolic": 120, "diastolic": 80, "pulse": 72}
    -- Sugar: {"value": 110, "type": "fasting", "unit": "mg/dL"}
    -- Weight: {"value": 70.5, "unit": "kg", "bmi": 22.5}
    -- Temp: {"value": 98.6, "unit": "F"}
    -- Heart Rate: {"value": 72, "unit": "bpm"}
    -- SpO2: {"value": 98, "unit": "%"}
    
    -- Context
    measured_at TIMESTAMP WITH TIME ZONE NOT NULL,
    notes TEXT,
    
    -- Device Info (if from wearable/device)
    device_name VARCHAR(100),
    device_id VARCHAR(255),
    
    -- Normal Range (calculated at insert)
    is_normal BOOLEAN,
    normal_range_min DECIMAL(10,2),
    normal_range_max DECIMAL(10,2),
    
    -- Alert
    alert_triggered BOOLEAN DEFAULT FALSE,
    alert_severity VARCHAR(20), -- normal, warning, critical
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Medicines Table
CREATE TABLE medicines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Basic Info
    brand_name VARCHAR(255) NOT NULL,
    generic_name VARCHAR(255) NOT NULL,
    manufacturer VARCHAR(255),
    
    -- Classification
    category VARCHAR(100), -- allopathic, ayurvedic, homeopathic
    drug_class VARCHAR(100), -- analgesic, antibiotic, etc.
    schedule VARCHAR(20), -- H, H1, X (Indian drug schedules)
    
    -- Details
    dosage_form VARCHAR(50), -- tablet, capsule, syrup, injection, cream
    strength VARCHAR(50), -- 500mg, 10ml, etc.
    package_size VARCHAR(50), -- 10 tablets, 100ml, etc.
    
    -- Usage
    indications TEXT[], -- What it's used for
    contraindications TEXT[], -- When NOT to use
    side_effects TEXT[],
    precautions TEXT[],
    
    -- Pregnancy & Lactation
    pregnancy_category VARCHAR(10), -- A, B, C, D, X
    lactation_safety VARCHAR(20), -- safe, cautious, avoid
    
    -- Pricing (Indian market)
    mrp DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'INR',
    
    -- Availability
    is_prescription_required BOOLEAN DEFAULT TRUE,
    is_available BOOLEAN DEFAULT TRUE,
    
    -- Search
    search_vector TSVECTOR, -- For full-text search
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    data_source VARCHAR(100), -- drugbank, fda, cdsco, manual
    
    UNIQUE(brand_name, strength, manufacturer)
);

-- Drug Interactions Table
CREATE TABLE drug_interactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    medicine1_id UUID NOT NULL REFERENCES medicines(id),
    medicine2_id UUID NOT NULL REFERENCES medicines(id),
    
    -- Interaction Details
    severity VARCHAR(20) NOT NULL, -- mild, moderate, severe, contraindicated
    mechanism TEXT, -- How the interaction occurs
    effect TEXT, -- What happens
    management TEXT, -- How to manage
    
    -- References
    evidence_level VARCHAR(20), -- established, probable, suspected, theoretical
    references TEXT[],
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(medicine1_id, medicine2_id),
    CHECK (medicine1_id < medicine2_id) -- Prevent duplicates (A,B) and (B,A)
);

-- User Medications (Current prescriptions)
CREATE TABLE user_medications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    family_member_id UUID REFERENCES family_members(id),
    medicine_id UUID REFERENCES medicines(id),
    
    -- Prescription Details
    prescribed_by_doctor_id UUID REFERENCES doctors(id),
    prescription_id UUID REFERENCES health_records(id),
    
    -- Dosage
    dosage VARCHAR(50), -- "1 tablet", "5ml", "2 drops"
    frequency VARCHAR(50), -- "twice daily", "every 8 hours", "as needed"
    timing VARCHAR(50), -- "before food", "after food", "with food"
    duration_days INTEGER,
    start_date DATE,
    end_date DATE,
    
    -- Instructions
    instructions TEXT,
    special_instructions TEXT, -- "Take with water", "Avoid alcohol"
    
    -- Status
    status VARCHAR(20) DEFAULT 'active', -- active, completed, discontinued, on_hold
    discontinuation_reason TEXT,
    
    -- Adherence Tracking
    total_doses INTEGER,
    doses_taken INTEGER DEFAULT 0,
    doses_missed INTEGER DEFAULT 0,
    adherence_percentage DECIMAL(5,2) DEFAULT 100.0,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Medication Reminders Table
CREATE TABLE medication_reminders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_medication_id UUID NOT NULL REFERENCES user_medications(id) ON DELETE CASCADE,
    
    -- Schedule
    reminder_time TIME NOT NULL,
    days_of_week INTEGER[] DEFAULT '{0,1,2,3,4,5,6}', -- All days by default
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    is_snoozed BOOLEAN DEFAULT FALSE,
    snooze_until TIMESTAMP WITH TIME ZONE,
    
    -- Notification Settings
    notification_sound VARCHAR(100) DEFAULT 'default',
    vibration_enabled BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Reminder Logs (Adherence tracking)
CREATE TABLE reminder_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reminder_id UUID NOT NULL REFERENCES medication_reminders(id),
    scheduled_time TIMESTAMP WITH TIME ZONE NOT NULL,
    
    -- Response
    action VARCHAR(20) NOT NULL, -- taken, skipped, snoozed, missed
    action_time TIMESTAMP WITH TIME ZONE,
    
    -- Details
    taken_with_food BOOLEAN,
    notes TEXT,
    
    -- Location (if available)
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Symptom Checks Table (AI/ML predictions)
CREATE TABLE symptom_checks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    family_member_id UUID REFERENCES family_members(id),
    
    -- Input
    symptoms TEXT[] NOT NULL,
    body_parts TEXT[],
    duration_days INTEGER,
    severity VARCHAR(20), -- mild, moderate, severe
    
    -- AI Prediction
    predicted_conditions JSONB, -- [{"disease": "Malaria", "confidence": 0.85}]
    top_prediction VARCHAR(255),
    confidence_score DECIMAL(5,2),
    
    -- Follow-up
    follow_up_questions JSONB,
    user_responses JSONB,
    
    -- Recommendation
    recommended_action VARCHAR(50), -- self_care, see_doctor, emergency
    urgency_level VARCHAR(20), -- low, medium, high, critical
    
    -- Doctor Consultation (if booked)
    appointment_id UUID REFERENCES appointments(id),
    
    -- Feedback
    was_accurate BOOLEAN,
    actual_diagnosis VARCHAR(255),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- First Aid Scenarios Table
CREATE TABLE first_aid_scenarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Content
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL, -- common, medical, pediatric, environmental, mental
    severity VARCHAR(20), -- minor, moderate, major, life_threatening
    
    -- Steps (ordered JSON array)
    steps JSONB NOT NULL,
    -- [{"step": 1, "title": "Check breathing", "description": "...", "image_url": "..."}]
    
    -- Media
    image_urls TEXT[],
    video_url TEXT,
    audio_url TEXT,
    
    -- Warnings
    dos TEXT[],
    donts TEXT[],
    when_to_call_emergency TEXT,
    
    -- Metadata
    is_offline_available BOOLEAN DEFAULT TRUE,
    download_priority INTEGER DEFAULT 0, -- Higher = download first
    
    -- Search
    search_vector TSVECTOR,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Health Articles Table
CREATE TABLE health_articles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Content
    title VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255),
    content TEXT NOT NULL,
    summary TEXT,
    
    -- Categorization
    category VARCHAR(100) NOT NULL, -- nutrition, exercise, mental_health, chronic_disease, womens_health, child_health
    tags TEXT[],
    
    -- Media
    cover_image_url TEXT,
    image_urls TEXT[],
    video_url TEXT,
    
    -- Author
    author_name VARCHAR(255),
    author_credentials VARCHAR(255),
    reviewed_by VARCHAR(255), -- Medical reviewer
    
    -- SEO
    slug VARCHAR(255) UNIQUE,
    meta_description TEXT,
    keywords TEXT[],
    
    -- Engagement
    view_count INTEGER DEFAULT 0,
    like_count INTEGER DEFAULT 0,
    share_count INTEGER DEFAULT 0,
    read_time_minutes INTEGER,
    
    -- Status
    status VARCHAR(20) DEFAULT 'draft', -- draft, published, archived
    published_at TIMESTAMP WITH TIME ZONE,
    
    -- Offline
    is_offline_available BOOLEAN DEFAULT FALSE,
    download_priority INTEGER DEFAULT 0,
    
    -- Search
    search_vector TSVECTOR,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Emergency Contacts Table
CREATE TABLE emergency_contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Contact Info
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL, -- ambulance, police, fire, hospital, blood_bank, poison_control
    phone_numbers TEXT[] NOT NULL, -- Multiple numbers possible
    
    -- Location
    country VARCHAR(100) DEFAULT 'India',
    state VARCHAR(100),
    city VARCHAR(100),
    address TEXT,
    
    -- Details
    is_toll_free BOOLEAN DEFAULT FALSE,
    is_available_24x7 BOOLEAN DEFAULT TRUE,
    languages_supported TEXT[],
    
    -- Metadata
    is_offline_available BOOLEAN DEFAULT TRUE,
    priority INTEGER DEFAULT 0, -- Display order
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Activity Logs (Audit Trail)
CREATE TABLE activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    
    -- Action Details
    action VARCHAR(100) NOT NULL, -- login, logout, view, create, update, delete, share, download
    entity_type VARCHAR(50) NOT NULL, -- user, appointment, health_record, medication, etc.
    entity_id UUID,
    
    -- Context
    description TEXT,
    metadata JSONB,
    
    -- IP & Device
    ip_address INET,
    user_agent TEXT,
    device_type VARCHAR(50), -- mobile, tablet, desktop
    app_version VARCHAR(20),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_auth_provider ON users(auth_provider, auth_provider_id);
CREATE INDEX idx_family_members_user_id ON family_members(user_id);
CREATE INDEX idx_doctors_specialties ON doctors USING GIN(specialties);
CREATE INDEX idx_doctors_location ON doctors(clinic_city, clinic_state);
CREATE INDEX idx_appointments_user_id ON appointments(user_id);
CREATE INDEX idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_health_records_user_id ON health_records(user_id);
CREATE INDEX idx_health_records_type ON health_records(record_type);
CREATE INDEX idx_health_records_date ON health_records(record_date);
CREATE INDEX idx_health_metrics_user_id ON health_metrics(user_id);
CREATE INDEX idx_health_metrics_type ON health_metrics(metric_type);
CREATE INDEX idx_health_metrics_measured_at ON health_metrics(measured_at);
CREATE INDEX idx_medicines_brand_name ON medicines(brand_name);
CREATE INDEX idx_medicines_generic_name ON medicines(generic_name);
CREATE INDEX idx_medicines_search ON medicines USING GIN(search_vector);
CREATE INDEX idx_drug_interactions_medicine1 ON drug_interactions(medicine1_id);
CREATE INDEX idx_drug_interactions_medicine2 ON drug_interactions(medicine2_id);
CREATE INDEX idx_user_medications_user_id ON user_medications(user_id);
CREATE INDEX idx_user_medications_status ON user_medications(status);
CREATE INDEX idx_medication_reminders_user_medication ON medication_reminders(user_medication_id);
CREATE INDEX idx_symptom_checks_user_id ON symptom_checks(user_id);
CREATE INDEX idx_first_aid_category ON first_aid_scenarios(category);
CREATE INDEX idx_first_aid_search ON first_aid_scenarios USING GIN(search_vector);
CREATE INDEX idx_articles_category ON health_articles(category);
CREATE INDEX idx_articles_status ON health_articles(status);
CREATE INDEX idx_articles_search ON health_articles USING GIN(search_vector);
CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at);

-- Full-text search triggers
CREATE OR REPLACE FUNCTION update_search_vector()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'medicines' THEN
        NEW.search_vector := to_tsvector('english', 
            COALESCE(NEW.brand_name, '') || ' ' ||
            COALESCE(NEW.generic_name, '') || ' ' ||
            COALESCE(NEW.manufacturer, '') || ' ' ||
            COALESCE(NEW.drug_class, '') || ' ' ||
            COALESCE(array_to_string(NEW.indications, ' '), '')
        );
    ELSIF TG_TABLE_NAME = 'first_aid_scenarios' THEN
        NEW.search_vector := to_tsvector('english',
            COALESCE(NEW.title, '') || ' ' ||
            COALESCE(NEW.category, '') || ' ' ||
            COALESCE(NEW.steps::text, '')
        );
    ELSIF TG_TABLE_NAME = 'health_articles' THEN
        NEW.search_vector := to_tsvector('english',
            COALESCE(NEW.title, '') || ' ' ||
            COALESCE(NEW.content, '') || ' ' ||
            COALESCE(NEW.summary, '') || ' ' ||
            COALESCE(array_to_string(NEW.tags, ' '), '')
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER medicines_search_vector_update
    BEFORE INSERT OR UPDATE ON medicines
    FOR EACH ROW EXECUTE FUNCTION update_search_vector();

CREATE TRIGGER first_aid_search_vector_update
    BEFORE INSERT OR UPDATE ON first_aid_scenarios
    FOR EACH ROW EXECUTE FUNCTION update_search_vector();

CREATE TRIGGER articles_search_vector_update
    BEFORE INSERT OR UPDATE ON health_articles
    FOR EACH ROW EXECUTE FUNCTION update_search_vector();

-- ============================================================
-- MONGODB SCHEMA (Unstructured Data - Document Store)
-- ============================================================

/*
Collection: health_documents
{
  _id: ObjectId,
  user_id: UUID (string),
  family_member_id: UUID (string, optional),
  
  // File metadata
  file_name: String,
  file_size: Number,
  mime_type: String,
  upload_date: Date,
  
  // GridFS reference
  gridfs_file_id: ObjectId,
  
  // OCR results
  ocr: {
    text: String,
    confidence: Number,
    extracted_data: {
      doctor_name: String,
      clinic_name: String,
      date: Date,
      medicines: [{
        name: String,
        dosage: String,
        frequency: String
      }]
    }
  },
  
  // Thumbnails
  thumbnails: {
    small: String, // URL
    medium: String,
    large: String
  },
  
  // Metadata
  tags: [String],
  category: String, // prescription, lab_report, imaging, etc.
  
  // Sharing
  shared_with: [{
    doctor_id: UUID (string),
    shared_at: Date,
    expires_at: Date,
    access_token: String
  }],
  
  created_at: Date,
  updated_at: Date
}

Collection: chat_messages
{
  _id: ObjectId,
  consultation_id: UUID (string),
  
  sender: {
    type: String, // patient, doctor, system
    user_id: UUID (string, optional)
  },
  
  message: {
    type: String, // text, image, file, prescription
    content: String,
    media_url: String (optional),
    file_id: ObjectId (optional)
  },
  
  // For AI/ML
  sentiment: String, // positive, neutral, negative
  intent: String, // question, answer, follow_up
  
  read_by: [{
    user_id: UUID (string),
    read_at: Date
  }],
  
  created_at: Date
}

Collection: consultation_recordings
{
  _id: ObjectId,
  consultation_id: UUID (string),
  
  // Recording metadata
  recording_url: String,
  duration_seconds: Number,
  file_size: Number,
  
  // Transcription
  transcription: {
    text: String,
    confidence: Number,
    language: String
  },
  
  // AI Analysis
  ai_summary: String,
  key_points: [String],
  action_items: [String],
  
  created_at: Date
}

Collection: user_sessions
{
  _id: ObjectId,
  user_id: UUID (string),
  
  // Session data
  device_info: {
    type: String, // mobile, tablet, desktop
    os: String,
    os_version: String,
    app_version: String,
    device_id: String
  },
  
  // JWT tokens
  tokens: {
    access_token: String,
    refresh_token: String,
    expires_at: Date
  },
  
  // Location
  location: {
    country: String,
    city: String,
    coordinates: [Number] // [longitude, latitude]
  },
  
  // Activity
  last_active_at: Date,
  login_at: Date,
  logout_at: Date (optional),
  
  created_at: Date
}

Collection: ml_predictions
{
  _id: ObjectId,
  
  // Input
  input_type: String, // symptoms, image, text
  input_data: Object,
  
  // Model info
  model_version: String,
  model_name: String,
  
  // Output
  predictions: [{
    label: String,
    confidence: Number,
    metadata: Object
  }],
  
  // Feedback
  user_feedback: {
    was_accurate: Boolean,
    correct_label: String,
    feedback_text: String
  },
  
  // Performance
  inference_time_ms: Number,
  
  created_at: Date
}
*/

-- ============================================================
-- REDIS SCHEMA (Cache & Session Store)
-- ============================================================

/*
Key Patterns:

# Sessions
session:{user_id} -> Hash {
  access_token: string,
  refresh_token: string,
  expires_at: timestamp,
  device_id: string
}
TTL: 24 hours

# OTP Cache
otp:{phone_or_email} -> String {
  code: "123456",
  attempts: 0,
  created_at: timestamp
}
TTL: 5 minutes (300 seconds)

# Rate Limiting
rate_limit:{endpoint}:{user_id} -> Counter
TTL: 15 minutes

# Search Cache
search:doctors:{hash} -> JSON [doctor_ids]
TTL: 10 minutes

search:medicines:{hash} -> JSON [medicine_ids]
TTL: 30 minutes

# Doctor Availability Cache
availability:doctor:{doctor_id}:{date} -> JSON {
  slots: [{
    time: "10:00",
    available: true
  }]
}
TTL: 5 minutes

# User Preferences Cache
prefs:{user_id} -> Hash {
  language: "en",
  theme: "light",
  notifications: true
}
TTL: 1 hour

# Health Metrics Cache (Recent)
metrics:{user_id}:{type}:latest -> JSON {
  value: Object,
  measured_at: timestamp
}
TTL: 1 hour

# Offline Content Sync Queue
sync_queue:{user_id} -> List [{
  action: "create",
  entity: "health_metric",
  data: Object,
  created_at: timestamp
}]

# Notification Queue
notifications:{user_id} -> List [{
  type: "reminder",
  title: String,
  body: String,
  scheduled_at: timestamp
}]

# Feature Flags
feature:{flag_name} -> String "true" or "false"

# A/B Testing
ab_test:{test_id}:{user_id} -> String "variant_a" or "variant_b"
*/

-- ============================================================
-- SQLITE SCHEMA (Local Offline Storage - Mobile App)
-- ============================================================

-- Users (Local cache of logged-in user)
CREATE TABLE local_users (
    id TEXT PRIMARY KEY,
    email TEXT,
    first_name TEXT,
    last_name TEXT,
    phone TEXT,
    is_active INTEGER DEFAULT 1,
    
    -- Profile
    date_of_birth TEXT,
    gender TEXT,
    blood_group TEXT,
    height_cm INTEGER,
    weight_kg REAL,
    allergies TEXT, -- JSON array
    chronic_conditions TEXT, -- JSON array
    current_medications TEXT, -- JSON
    
    -- Preferences
    preferred_language TEXT DEFAULT 'en',
    theme_mode TEXT DEFAULT 'light',
    notification_enabled INTEGER DEFAULT 1,
    
    -- Sync
    last_sync_at TEXT,
    is_sync_pending INTEGER DEFAULT 0,
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Family Members (Local)
CREATE TABLE local_family_members (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT,
    relationship TEXT NOT NULL,
    date_of_birth TEXT,
    gender TEXT,
    blood_group TEXT,
    height_cm INTEGER,
    weight_kg REAL,
    allergies TEXT,
    chronic_conditions TEXT,
    current_medications TEXT,
    is_primary INTEGER DEFAULT 0,
    
    -- Sync
    server_id TEXT, -- UUID from PostgreSQL
    sync_status TEXT DEFAULT 'synced', -- synced, pending, conflict
    last_sync_at TEXT,
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Health Metrics (Local)
CREATE TABLE local_health_metrics (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    family_member_id TEXT,
    metric_type TEXT NOT NULL,
    values TEXT NOT NULL, -- JSON
    measured_at TEXT NOT NULL,
    notes TEXT,
    device_name TEXT,
    is_normal INTEGER,
    alert_triggered INTEGER DEFAULT 0,
    alert_severity TEXT,
    
    -- Sync
    server_id TEXT,
    sync_status TEXT DEFAULT 'pending',
    last_sync_at TEXT,
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Medication Reminders (Local)
CREATE TABLE local_reminders (
    id TEXT PRIMARY KEY,
    user_medication_id TEXT NOT NULL,
    reminder_time TEXT NOT NULL,
    days_of_week TEXT DEFAULT '[0,1,2,3,4,5,6]', -- JSON array
    is_active INTEGER DEFAULT 1,
    is_snoozed INTEGER DEFAULT 0,
    snooze_until TEXT,
    notification_sound TEXT DEFAULT 'default',
    vibration_enabled INTEGER DEFAULT 1,
    
    -- Sync
    server_id TEXT,
    sync_status TEXT DEFAULT 'synced',
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Reminder Logs (Local)
CREATE TABLE local_reminder_logs (
    id TEXT PRIMARY KEY,
    reminder_id TEXT NOT NULL,
    scheduled_time TEXT NOT NULL,
    action TEXT NOT NULL, -- taken, skipped, snoozed, missed
    action_time TEXT,
    taken_with_food INTEGER,
    notes TEXT,
    latitude REAL,
    longitude REAL,
    
    -- Sync
    server_id TEXT,
    sync_status TEXT DEFAULT 'pending',
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Offline First Aid (Pre-downloaded)
CREATE TABLE local_first_aid (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    severity TEXT,
    steps TEXT NOT NULL, -- JSON
    image_urls TEXT, -- JSON array
    video_url TEXT,
    audio_url TEXT,
    dos TEXT, -- JSON array
    donts TEXT, -- JSON array
    when_to_call_emergency TEXT,
    download_priority INTEGER DEFAULT 0,
    is_downloaded INTEGER DEFAULT 0,
    downloaded_at TEXT,
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Offline Medicines (Pre-downloaded)
CREATE TABLE local_medicines (
    id TEXT PRIMARY KEY,
    brand_name TEXT NOT NULL,
    generic_name TEXT NOT NULL,
    manufacturer TEXT,
    category TEXT,
    drug_class TEXT,
    schedule TEXT,
    dosage_form TEXT,
    strength TEXT,
    indications TEXT, -- JSON array
    contraindications TEXT, -- JSON array
    side_effects TEXT, -- JSON array
    precautions TEXT, -- JSON array
    mrp REAL,
    is_prescription_required INTEGER DEFAULT 1,
    is_downloaded INTEGER DEFAULT 0,
    downloaded_at TEXT,
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Offline Articles (Pre-downloaded)
CREATE TABLE local_articles (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    subtitle TEXT,
    content TEXT NOT NULL,
    summary TEXT,
    category TEXT NOT NULL,
    tags TEXT, -- JSON array
    cover_image_url TEXT,
    image_urls TEXT, -- JSON array
    author_name TEXT,
    read_time_minutes INTEGER,
    is_bookmarked INTEGER DEFAULT 0,
    is_downloaded INTEGER DEFAULT 0,
    downloaded_at TEXT,
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Offline Emergency Contacts
CREATE TABLE local_emergency_contacts (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    phone_numbers TEXT NOT NULL, -- JSON array
    country TEXT DEFAULT 'India',
    state TEXT,
    city TEXT,
    is_toll_free INTEGER DEFAULT 0,
    is_available_24x7 INTEGER DEFAULT 1,
    priority INTEGER DEFAULT 0,
    
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Sync Queue (For offline-online sync)
CREATE TABLE sync_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    action TEXT NOT NULL, -- create, update, delete
    entity_type TEXT NOT NULL, -- health_metric, family_member, reminder, etc.
    local_id TEXT NOT NULL,
    server_id TEXT,
    data TEXT NOT NULL, -- JSON
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    retry_count INTEGER DEFAULT 0,
    last_retry_at TEXT,
    error_message TEXT,
    status TEXT DEFAULT 'pending' -- pending, processing, failed, completed
);

-- Indexes for SQLite
CREATE INDEX idx_local_metrics_user ON local_health_metrics(user_id);
CREATE INDEX idx_local_metrics_type ON local_health_metrics(metric_type);
CREATE INDEX idx_local_metrics_measured ON local_health_metrics(measured_at);
CREATE INDEX idx_local_reminders_medication ON local_reminders(user_medication_id);
CREATE INDEX idx_local_reminder_logs_reminder ON local_reminder_logs(reminder_id);
CREATE INDEX idx_sync_queue_user ON sync_queue(user_id);
CREATE INDEX idx_sync_queue_status ON sync_queue(status);
CREATE INDEX idx_local_first_aid_category ON local_first_aid(category);
CREATE INDEX idx_local_medicines_brand ON local_medicines(brand_name);
CREATE INDEX idx_local_articles_category ON local_articles(category);

-- ============================================================
-- HIVE BOX SCHEMA (Flutter Local Storage - Key-Value)
-- ============================================================

/*
Box: user_prefs
  key: "user_{user_id}"
  value: {
    "theme": "light",
    "language": "en",
    "font_size": "medium",
    "high_contrast": false,
    "reduce_motion": false,
    "screen_reader": false
  }

Box: auth_tokens
  key: "current_user"
  value: {
    "access_token": "jwt_token",
    "refresh_token": "refresh_token",
    "expires_at": "2026-06-09T20:00:00Z"
  }

Box: app_state
  key: "first_run"
  value: false
  
  key: "last_sync"
  value: "2026-06-08T20:00:00Z"
  
  key: "offline_mode_enabled"
  value: true

Box: notification_settings
  key: "user_{user_id}"
  value: {
    "medication_reminders": true,
    "appointment_reminders": true,
    "health_alerts": true,
    "promotional": false,
    "quiet_hours_start": "22:00",
    "quiet_hours_end": "07:00"
  }

Box: calculator_cache
  key: "bmi_history"
  value: [
    {"date": "2026-06-01", "bmi": 22.5, "weight": 70, "height": 175}
  ]
  
  key: "last_bmr_calculation"
  value: {
    "bmr": 1650,
    "tdee": 2200,
    "formula": "mifflin_st_jeor"
  }

Box: symptom_checker_history
  key: "user_{user_id}"
  value: [
    {
      "date": "2026-06-08",
      "symptoms": ["fever", "headache"],
      "prediction": "Malaria",
      "confidence": 0.75
    }
  ]

Box: drug_interaction_history
  key: "user_{user_id}"
  value: [
    {
      "date": "2026-06-08",
      "medicines": ["Dolo 650", "Crocin Advance"],
      "interactions": [
        {"severity": "mild", "description": "..."}
      ]
    }
  ]
*/

-- ============================================================
-- DATA RETENTION & ARCHIVAL POLICIES
-- ============================================================

-- Health metrics older than 2 years: Archive to cold storage
-- Activity logs older than 1 year: Aggregate and delete details
-- Deleted accounts: Soft delete for 90 days, then hard delete
-- OTP codes: Auto-delete after 5 minutes (Redis TTL)
-- Session tokens: Auto-delete after 24 hours (Redis TTL)
-- Search cache: Auto-delete after 10-30 minutes (Redis TTL)

-- ============================================================
-- SECURITY CONSIDERATIONS
-- ============================================================

-- 1. Field-level encryption for sensitive data:
--    - health_records.ocr_text (if contains sensitive info)
--    - users.phone (if required by regulations)
--    - chat_messages.message.content (end-to-end encryption)

-- 2. Row-level security (RLS) policies:
--    - Users can only see their own data
--    - Doctors can only see patient data they've been granted access to
--    - Family members can see each other's data with consent

-- 3. Audit logging:
--    - All data access logged in activity_logs
--    - Failed login attempts tracked
--    - Data exports logged

-- 4. Backup strategy:
--    - PostgreSQL: Daily automated backups
--    - MongoDB: Continuous backup with point-in-time recovery
--    - Redis: No backup needed (cache only)
--    - SQLite: Sync to server, local is cache only

-- ============================================================
-- END OF SCHEMA
-- ============================================================