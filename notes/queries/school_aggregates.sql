-- "How many students are enrolled at each school, broken down by grade level? Include the district (LEA) name. Order by district, school, then grade level." Came up with query:

WITH
    cte1 AS (
        SELECT
            COUNT(*) AS studentCount,
            sch.schoolid,
            descriptor.descriptorid,
            sch.localeducationagencyid,
            CASE
                WHEN descriptor.codevalue = 'First grade' THEN 1
                WHEN descriptor.codevalue = 'Second grade' THEN 2
                WHEN descriptor.codevalue = 'Third grade' THEN 3
                WHEN descriptor.codevalue = 'Fourth grade' THEN 4
                WHEN descriptor.codevalue = 'Fifth grade' THEN 5
                WHEN descriptor.codevalue = 'Sixth grade' THEN 6
                WHEN descriptor.codevalue = 'Seventh grade' THEN 7
                WHEN descriptor.codevalue = 'Eighth grade' THEN 8
                WHEN descriptor.codevalue = 'Ninth grade' THEN 9
                WHEN descriptor.codevalue = 'Tenth grade' THEN 10
                WHEN descriptor.codevalue = 'Eleventh grade' THEN 11
                WHEN descriptor.codevalue = 'Twelfth grade' THEN 12
                END AS grade
        FROM
            studentschoolassociation ssa
            JOIN student stu ON ssa.studentusi = stu.studentusi
            JOIN school sch ON sch.schoolid = ssa.schoolid
            JOIN descriptor descriptor ON descriptor.descriptorId = ssa.entrygradeleveldescriptorid
        GROUP BY
            sch.schoolid, descriptor.descriptorid
        )
SELECT
    agency.nameofinstitution AS district,
    organization.nameofinstitution AS school,
    cte1.grade,
    cte1.studentCount
FROM
    cte1
    JOIN educationorganization organization ON organization.educationorganizationid = cte1.schoolid
    JOIN educationorganization agency ON cte1.localeducationagencyid = agency.educationorganizationid
ORDER BY
    district,
    school,
    grade