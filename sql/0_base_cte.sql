/*
  Base CTE — digunakan ulang di semua query dashboard.
  Tabel: dataset | Format tanggal: DD/MM/YYYY
  - employee_status : 'Hired' jika termdate kosong, 'Terminated' jika terisi
  - age             : dihitung dinamis dari CURRENT_DATE
  - age_group       : <25 | 25-34 | 35-44 | 45-54 | 55+
*/

WITH employee_base AS (
  SELECT
    employee_id,
    first_name,
    last_name,
    gender,
    state,
    city,
    education_level,
    TO_DATE(birthdate,              'DD/MM/YYYY')  AS birthdate,
    TO_DATE(hiredate,               'DD/MM/YYYY')  AS hire_date,
    TO_DATE(NULLIF(termdate, ''),   'DD/MM/YYYY')  AS term_date,
    department,
    job_title,
    salary::numeric                                AS salary,
    performance_rating,

    CASE
      WHEN NULLIF(termdate, '') IS NULL THEN 'Hired'
      ELSE 'Terminated'
    END AS employee_status,

    EXTRACT(YEAR FROM AGE(
      CURRENT_DATE,
      TO_DATE(birthdate, 'DD/MM/YYYY')
    ))::int AS age,

    CASE
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, TO_DATE(birthdate, 'DD/MM/YYYY'))) < 25              THEN '<25'
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, TO_DATE(birthdate, 'DD/MM/YYYY'))) BETWEEN 25 AND 34 THEN '25-34'
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, TO_DATE(birthdate, 'DD/MM/YYYY'))) BETWEEN 35 AND 44 THEN '35-44'
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, TO_DATE(birthdate, 'DD/MM/YYYY'))) BETWEEN 45 AND 54 THEN '45-54'
      ELSE '55+'
    END AS age_group

  FROM dataset
)
SELECT * FROM employee_base;
