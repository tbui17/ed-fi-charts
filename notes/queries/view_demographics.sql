CREATE OR REPLACE VIEW warehouse.v_demographics AS
WITH
    sex AS (
        SELECT sch.school_id, stu.sex AS value, COUNT(*) AS count,
            COUNT(*)::FLOAT / SUM(COUNT(*)) OVER (PARTITION BY sch.school_id) AS percent
        FROM warehouse.enrollment_fact
        JOIN warehouse.dim_student stu ON enrollment_fact.student_unique_id = stu.student_unique_id
        JOIN warehouse.dim_school sch ON enrollment_fact.school_id = sch.school_id
        GROUP BY sch.school_id, stu.sex
    ),
    race AS (
        SELECT sch.school_id, bsr.race AS value, COUNT(*) AS count,
            COUNT(*)::FLOAT / SUM(COUNT(*)) OVER (PARTITION BY sch.school_id) AS percent
        FROM warehouse.enrollment_fact
        JOIN warehouse.dim_student stu ON enrollment_fact.student_unique_id = stu.student_unique_id
        JOIN warehouse.dim_school sch ON enrollment_fact.school_id = sch.school_id
        LEFT JOIN warehouse.bridge_student_race bsr ON stu.student_unique_id = bsr.student_unique_id
        GROUP BY sch.school_id, bsr.race
    ),
    disability AS (
        SELECT sch.school_id, bsd.disability AS value, COUNT(*) AS count,
            COUNT(*)::FLOAT / SUM(COUNT(*)) OVER (PARTITION BY sch.school_id) AS percent
        FROM warehouse.enrollment_fact
        JOIN warehouse.dim_student stu ON enrollment_fact.student_unique_id = stu.student_unique_id
        JOIN warehouse.dim_school sch ON enrollment_fact.school_id = sch.school_id
        LEFT JOIN warehouse.bridge_student_disability bsd ON stu.student_unique_id = bsd.student_unique_id
        GROUP BY sch.school_id, bsd.disability
    ),
    language AS (
        SELECT sch.school_id, bsl.language AS value, COUNT(*) AS count,
            COUNT(*)::FLOAT / SUM(COUNT(*)) OVER (PARTITION BY sch.school_id) AS percent
        FROM warehouse.enrollment_fact
        JOIN warehouse.dim_student stu ON enrollment_fact.student_unique_id = stu.student_unique_id
        JOIN warehouse.dim_school sch ON enrollment_fact.school_id = sch.school_id
        LEFT JOIN warehouse.bridge_student_language bsl ON stu.student_unique_id = bsl.student_unique_id
        GROUP BY sch.school_id, bsl.language
    ),
    tribal AS (
        SELECT sch.school_id, bst.tribal_affiliation AS value, COUNT(*) AS count,
            COUNT(*)::FLOAT / SUM(COUNT(*)) OVER (PARTITION BY sch.school_id) AS percent
        FROM warehouse.enrollment_fact
        JOIN warehouse.dim_student stu ON enrollment_fact.student_unique_id = stu.student_unique_id
        JOIN warehouse.dim_school sch ON enrollment_fact.school_id = sch.school_id
        LEFT JOIN warehouse.bridge_student_tribal bst ON stu.student_unique_id = bst.student_unique_id
        GROUP BY sch.school_id, bst.tribal_affiliation
    ),
    lep_status AS (
        SELECT sch.school_id, stu.lep_status AS value, COUNT(*) AS count,
            COUNT(*)::FLOAT / SUM(COUNT(*)) OVER (PARTITION BY sch.school_id) AS percent
        FROM warehouse.enrollment_fact
        JOIN warehouse.dim_student stu ON enrollment_fact.student_unique_id = stu.student_unique_id
        JOIN warehouse.dim_school sch ON enrollment_fact.school_id = sch.school_id
        GROUP BY sch.school_id, stu.lep_status
    ),
    hispanic_or_latino AS (
        SELECT sch.school_id, stu.hispanic_latino_ethnicity::TEXT AS value, COUNT(*) AS count,
            COUNT(*)::FLOAT / SUM(COUNT(*)) OVER (PARTITION BY sch.school_id) AS percent
        FROM warehouse.enrollment_fact
        JOIN warehouse.dim_student stu ON enrollment_fact.student_unique_id = stu.student_unique_id
        JOIN warehouse.dim_school sch ON enrollment_fact.school_id = sch.school_id
        GROUP BY sch.school_id, stu.hispanic_latino_ethnicity
    ),
    combined AS (
        SELECT *, 'sex' AS type FROM sex
        UNION ALL SELECT *, 'race' AS type FROM race
        UNION ALL SELECT *, 'disability' AS type FROM disability
        UNION ALL SELECT *, 'language' AS type FROM language
        UNION ALL SELECT *, 'tribal' AS type FROM tribal
        UNION ALL SELECT *, 'lep_status' AS type FROM lep_status
        UNION ALL SELECT school_id, value, count, percent, 'hispanic_or_latino' AS type FROM hispanic_or_latino
    )
SELECT
    sch.district_name,
    sch.name AS school_name,
    c.type,
    c.value,
    c.count,
    c.percent
FROM combined c
JOIN warehouse.dim_school sch ON c.school_id = sch.school_id
WHERE c.value IS NOT NULL AND sch.district_name IS NOT NULL
ORDER BY sch.district_name, sch.name, c.type, c.count DESC;
