
CREATE SCHEMA IF NOT EXISTS warehouse;

CREATE TABLE warehouse.dim_student (
    student_key SERIAL PRIMARY KEY,
    student_unique_id VARCHAR(32) UNIQUE NOT NULL,
    first_name VARCHAR(75),
    middle_name VARCHAR(75),
    last_name VARCHAR(75),
    birth_date DATE,
    sex VARCHAR(60),
    gender_identity VARCHAR(60),
    hispanic_latino_ethnicity BOOLEAN,
    lep_status VARCHAR(60),
    physical_street VARCHAR(150),
    physical_city VARCHAR(75),
    physical_postal_code VARCHAR(17),
    physical_state VARCHAR(50),
    physical_county VARCHAR(75),
    mailing_street VARCHAR(150),
    mailing_city VARCHAR(75),
    mailing_postal_code VARCHAR(17),
    mailing_state VARCHAR(50),
    mailing_county VARCHAR(75)
);


CREATE TABLE warehouse.dim_school (
    school_key SERIAL PRIMARY KEY,
    school_id BIGINT UNIQUE NOT NULL,
    name VARCHAR(150),
    short_name VARCHAR(75),
    website VARCHAR(255),
    operational_status VARCHAR(60),
    school_type VARCHAR(60),
    school_category VARCHAR(60),
    charter_status VARCHAR(60),
    title_i_designation VARCHAR(120),
    funding_control VARCHAR(60),
    district_name VARCHAR(150),
    district_short_name VARCHAR(75)
);


CREATE TABLE warehouse.enrollment_fact (
    enrollment_key SERIAL PRIMARY KEY,
    student_unique_id VARCHAR(32) REFERENCES warehouse.dim_student(student_unique_id),
    school_id BIGINT REFERENCES warehouse.dim_school(school_id),
    grade_number INT,
    grade_band VARCHAR(20),
    grade_band_order INT,
    ceds_grade_code VARCHAR(10),
    entry_date DATE NOT NULL,
    exit_date DATE,
    entry_type VARCHAR(60),
    exit_type VARCHAR(60),
    enrollment_type VARCHAR(60),
    residency_status VARCHAR(60),
    school_year SMALLINT,
    class_of_school_year SMALLINT,
    fte NUMERIC(5,4),
    is_primary_school BOOLEAN,
    employed_while_enrolled BOOLEAN,
    repeat_grade_indicator BOOLEAN,
    school_choice BOOLEAN,
    school_choice_transfer BOOLEAN,
    calendar_code VARCHAR(60),
    next_year_school_name VARCHAR(150),
    next_year_grade_level VARCHAR(60)
);

CREATE TABLE warehouse.bridge_student_race (
    student_unique_id VARCHAR(32) REFERENCES warehouse.dim_student(student_unique_id),
    race VARCHAR(60) NOT NULL,
    PRIMARY KEY (student_unique_id, race)
);

CREATE TABLE warehouse.bridge_student_language (
    student_unique_id VARCHAR(32) REFERENCES warehouse.dim_student(student_unique_id),
    language VARCHAR(60) NOT NULL,
    PRIMARY KEY (student_unique_id, language)
);

CREATE TABLE warehouse.bridge_student_disability (
    student_unique_id VARCHAR(32) REFERENCES warehouse.dim_student(student_unique_id),
    disability VARCHAR(60) NOT NULL,
    PRIMARY KEY (student_unique_id, disability)
);

CREATE TABLE warehouse.bridge_student_tribal (
    student_unique_id VARCHAR(32) REFERENCES warehouse.dim_student(student_unique_id),
    tribal_affiliation VARCHAR(60) NOT NULL,
    PRIMARY KEY (student_unique_id, tribal_affiliation)
);
