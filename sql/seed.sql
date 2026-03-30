
--- school

INSERT INTO warehouse.dim_school (
    school_id, name, short_name, website, operational_status,
    school_type, school_category, charter_status,
    title_i_designation, funding_control,
    district_name, district_short_name
)
SELECT
    sch.schoolid,
    eo_school.nameofinstitution,
    eo_school.shortnameofinstitution,
    eo_school.website,
    d_status.codevalue,
    d_type.codevalue,
    d_cat.codevalue,
    d_charter.codevalue,
    d_title.codevalue,
    d_funding.codevalue,
    eo_lea.nameofinstitution,
    eo_lea.shortnameofinstitution
FROM edfi.school sch
JOIN edfi.educationorganization eo_school ON sch.schoolid = eo_school.educationorganizationid
LEFT JOIN edfi.educationorganization eo_lea ON sch.localeducationagencyid = eo_lea.educationorganizationid
LEFT JOIN edfi.schoolcategory sc ON sch.schoolid = sc.schoolid
LEFT JOIN edfi.descriptor d_status ON eo_school.operationalstatusdescriptorid = d_status.descriptorid
LEFT JOIN edfi.descriptor d_type ON sch.schooltypedescriptorid = d_type.descriptorid
LEFT JOIN edfi.descriptor d_cat ON sc.schoolcategorydescriptorid = d_cat.descriptorid
LEFT JOIN edfi.descriptor d_charter ON sch.charterstatusdescriptorid = d_charter.descriptorid
LEFT JOIN edfi.descriptor d_title ON sch.titleipartaschooldesignationdescriptorid = d_title.descriptorid
LEFT JOIN edfi.descriptor d_funding ON sch.administrativefundingcontroldescriptorid = d_funding.descriptorid;

--- student

WITH physical_addr AS (
    SELECT
        a.studentusi,
        a.educationorganizationid,
        a.streetnumbername,
        a.city,
        a.postalcode,
        d_state.codevalue AS state,
        a.nameofcounty
    FROM edfi.studenteducationorganizationassociationaddress a
    JOIN edfi.descriptor d_type ON a.addresstypedescriptorid = d_type.descriptorid
    LEFT JOIN edfi.descriptor d_state ON a.stateabbreviationdescriptorid = d_state.descriptorid
    WHERE d_type.codevalue = 'Physical'
),
mailing_addr AS (
    SELECT
        a.studentusi,
        a.educationorganizationid,
        a.streetnumbername,
        a.city,
        a.postalcode,
        d_state.codevalue AS state,
        a.nameofcounty
    FROM edfi.studenteducationorganizationassociationaddress a
    JOIN edfi.descriptor d_type ON a.addresstypedescriptorid = d_type.descriptorid
    LEFT JOIN edfi.descriptor d_state ON a.stateabbreviationdescriptorid = d_state.descriptorid
    WHERE d_type.codevalue = 'Mailing'
)
INSERT INTO warehouse.dim_student (
    student_unique_id, first_name, middle_name, last_name, birth_date,
    sex, gender_identity, hispanic_latino_ethnicity, lep_status,
    physical_street, physical_city, physical_postal_code, physical_state, physical_county,
    mailing_street, mailing_city, mailing_postal_code, mailing_state, mailing_county
)
SELECT
    s.studentuniqueid,
    s.firstname,
    s.middlename,
    s.lastsurname,
    s.birthdate,
    d_sex.codevalue,
    seoa.genderidentity,
    seoa.hispaniclatinoethnicity,
    d_lep.codevalue,
    pa.streetnumbername,
    pa.city,
    pa.postalcode,
    pa.state,
    pa.nameofcounty,
    ma.streetnumbername,
    ma.city,
    ma.postalcode,
    ma.state,
    ma.nameofcounty
FROM edfi.student s
LEFT JOIN edfi.studenteducationorganizationassociation seoa ON s.studentusi = seoa.studentusi
LEFT JOIN edfi.descriptor d_sex ON seoa.sexdescriptorid = d_sex.descriptorid
LEFT JOIN edfi.descriptor d_lep ON seoa.limitedenglishproficiencydescriptorid = d_lep.descriptorid
LEFT JOIN physical_addr pa ON pa.studentusi = seoa.studentusi AND pa.educationorganizationid = seoa.educationorganizationid
LEFT JOIN mailing_addr ma ON ma.studentusi = seoa.studentusi AND ma.educationorganizationid = seoa.educationorganizationid;

--- bridge: races

INSERT INTO warehouse.bridge_student_race (student_unique_id, race)
SELECT DISTINCT s.studentuniqueid, d.codevalue
FROM edfi.studenteducationorganizationassociationrace r
JOIN edfi.studenteducationorganizationassociation seoa ON r.studentusi = seoa.studentusi AND r.educationorganizationid = seoa.educationorganizationid
JOIN edfi.student s ON seoa.studentusi = s.studentusi
JOIN edfi.descriptor d ON r.racedescriptorid = d.descriptorid
ON CONFLICT DO NOTHING;

--- bridge: languages

INSERT INTO warehouse.bridge_student_language (student_unique_id, language)
SELECT DISTINCT s.studentuniqueid, d.codevalue
FROM edfi.studenteducationorganizationassociationlanguage l
JOIN edfi.studenteducationorganizationassociation seoa ON l.studentusi = seoa.studentusi AND l.educationorganizationid = seoa.educationorganizationid
JOIN edfi.student s ON seoa.studentusi = s.studentusi
JOIN edfi.descriptor d ON l.languagedescriptorid = d.descriptorid
ON CONFLICT DO NOTHING;

--- bridge: disabilities

INSERT INTO warehouse.bridge_student_disability (student_unique_id, disability)
SELECT DISTINCT s.studentuniqueid, d.codevalue
FROM edfi.studenteducationorganizationassociationdisability dis
JOIN edfi.studenteducationorganizationassociation seoa ON dis.studentusi = seoa.studentusi AND dis.educationorganizationid = seoa.educationorganizationid
JOIN edfi.student s ON seoa.studentusi = s.studentusi
JOIN edfi.descriptor d ON dis.disabilitydescriptorid = d.descriptorid
ON CONFLICT DO NOTHING;

--- bridge: tribal affiliations

INSERT INTO warehouse.bridge_student_tribal (student_unique_id, tribal_affiliation)
SELECT DISTINCT s.studentuniqueid, d.codevalue
FROM edfi.studenteducationorganizationassociationtribalaffiliation t
JOIN edfi.studenteducationorganizationassociation seoa ON t.studentusi = seoa.studentusi AND t.educationorganizationid = seoa.educationorganizationid
JOIN edfi.student s ON seoa.studentusi = s.studentusi
JOIN edfi.descriptor d ON t.tribalaffiliationdescriptorid = d.descriptorid
ON CONFLICT DO NOTHING;

--- enrollment

WITH grade_map AS (
    SELECT * FROM (VALUES
        ('First grade',      1,  'Elementary', 1, '01'),
        ('Second grade',     2,  'Elementary', 1, '02'),
        ('Third grade',      3,  'Elementary', 1, '03'),
        ('Fourth grade',     4,  'Elementary', 1, '04'),
        ('Fifth grade',      5,  'Elementary', 1, '05'),
        ('Sixth grade',      6,  'Middle',     2, '06'),
        ('Seventh grade',    7,  'Middle',     2, '07'),
        ('Eighth grade',     8,  'Middle',     2, '08'),
        ('Ninth grade',      9,  'High',       3, '09'),
        ('Tenth grade',      10, 'High',       3, '10'),
        ('Eleventh grade',   11, 'High',       3, '11'),
        ('Twelfth grade',    12, 'High',       3, '12')
    ) AS t(edfi_code, grade_number, grade_band, grade_band_order, ceds_grade_code)
)
INSERT INTO warehouse.enrollment_fact (
    student_unique_id, school_id,
    grade_number, grade_band, grade_band_order, ceds_grade_code,
    entry_date, exit_date,
    entry_type, exit_type, enrollment_type, residency_status,
    school_year, class_of_school_year, fte,
    is_primary_school, employed_while_enrolled, repeat_grade_indicator,
    school_choice, school_choice_transfer,
    calendar_code, next_year_school_name, next_year_grade_level
)
SELECT
    s.studentuniqueid,
    ssa.schoolid,
    gm.grade_number,
    gm.grade_band,
    gm.grade_band_order,
    gm.ceds_grade_code,
    ssa.entrydate,
    ssa.exitwithdrawdate,
    d_entry.codevalue,
    d_exit.codevalue,
    d_enroll.codevalue,
    d_residency.codevalue,
    ssa.schoolyear,
    ssa.classofschoolyear,
    ssa.fulltimeequivalency,
    ssa.primaryschool,
    ssa.employedwhileenrolled,
    ssa.repeatgradeindicator,
    ssa.schoolchoice,
    ssa.schoolchoicetransfer,
    ssa.calendarcode,
    eo_next.nameofinstitution,
    d_next_grade.codevalue
FROM edfi.studentschoolassociation ssa
JOIN edfi.student s ON ssa.studentusi = s.studentusi
JOIN edfi.descriptor d_grade ON ssa.entrygradeleveldescriptorid = d_grade.descriptorid
LEFT JOIN grade_map gm ON d_grade.codevalue = gm.edfi_code
LEFT JOIN edfi.descriptor d_entry ON ssa.entrytypedescriptorid = d_entry.descriptorid
LEFT JOIN edfi.descriptor d_exit ON ssa.exitwithdrawtypedescriptorid = d_exit.descriptorid
LEFT JOIN edfi.descriptor d_enroll ON ssa.enrollmenttypedescriptorid = d_enroll.descriptorid
LEFT JOIN edfi.descriptor d_residency ON ssa.residencystatusdescriptorid = d_residency.descriptorid
LEFT JOIN edfi.educationorganization eo_next ON ssa.nextyearschoolid = eo_next.educationorganizationid
LEFT JOIN edfi.descriptor d_next_grade ON ssa.nextyeargradeleveldescriptorid = d_next_grade.descriptorid;