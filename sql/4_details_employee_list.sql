/*
  E1. Tampilkan daftar lengkap semua karyawan beserta detail kolom.
  - length_of_employment_years: untuk aktif → hire s/d hari ini,
    untuk terminasi → hire s/d term date
  - PostgreSQL: DATE - DATE = INTEGER (hari), bukan INTERVAL;
    gunakan pembagian / 365.25 lalu FLOOR()
*/
SELECT
  employee_id,
  CONCAT(first_name, ' ', last_name)     AS employee_name,
  gender,
  age,
  education_level,
  department,
  job_title,
  state,
  city,
  salary::numeric                        AS salary,
  CASE
    WHEN term_date IS NULL THEN 'Hired'
    ELSE 'Terminated'
  END                                    AS employment_status,
  hire_date,
  term_date,
  EXTRACT(YEAR FROM hire_date)           AS hire_year,
  EXTRACT(YEAR FROM term_date)           AS term_year,
  CASE
    WHEN term_date IS NULL
      THEN FLOOR((CURRENT_DATE - hire_date) / 365.25)::int
    ELSE   FLOOR((term_date   - hire_date) / 365.25)::int
  END                                    AS length_of_employment_years

FROM (
  SELECT *,
    hiredate AS hire_date,
    termdate AS term_date,
    EXTRACT(YEAR FROM AGE(
      CURRENT_DATE, birthdate))::int    AS age
  FROM dataset
) base;

/*
RESULTS (sample)
=======
| employee_id  | employee_name    | gender | age | education_level | department  | salary | employment_status | length_of_employment_years |
|--------------|------------------|--------|-----|-----------------|-------------|--------|-------------------|----------------------------|
| 00-95822412  | Danielle Johnson | Female | 45  | High School     | Customer S. | 81552  | Terminated        | 5                          |
| 00-42868828  | John Taylor      | Male   | 37  | Bachelor        | IT          | 107520 | Terminated        | 2                          |
| ...          | ...              | ...    | ... | ...             | ...         | ...    | ...               | ...                        |
*/


/*
  E2. Daftar karyawan dengan filter dinamis (Tableau Custom SQL).
  - Ganti placeholder :param dengan Tableau Parameters
  - Flag _is_all = 1 untuk menonaktifkan filter tersebut
*/
SELECT
  employee_id,
  CONCAT(first_name, ' ', last_name)     AS employee_name,
  gender,
  age,
  education_level,
  department,
  job_title,
  state,
  city,
  salary::numeric                        AS salary,
  CASE
    WHEN term_date IS NULL THEN 'Hired'
    ELSE 'Terminated'
  END                                    AS employment_status,
  hire_date,
  term_date,
  CASE
    WHEN term_date IS NULL
      THEN FLOOR((CURRENT_DATE - hire_date) / 365.25)::int
    ELSE   FLOOR((term_date   - hire_date) / 365.25)::int
  END                                    AS length_of_employment_years

FROM (
  SELECT *,
    hiredate AS hire_date,
    termdate AS term_date,
    EXTRACT(YEAR FROM AGE(
      CURRENT_DATE, birthdate))::int     AS age,
    CASE
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) < 25              THEN '<25'
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) BETWEEN 25 AND 34 THEN '25-34'
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) BETWEEN 35 AND 44 THEN '35-44'
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) BETWEEN 45 AND 54 THEN '45-54'
      ELSE '55+'
    END                                         AS age_group
  FROM dataset
) base

WHERE (:employee_id_is_all  = 1  OR employee_id      = :employee_id)
  AND (:gender_is_all       = 1  OR gender            = :gender)
  AND (:age_group_is_all    = 1  OR age_group         = :age_group)
  AND (:education_is_all    = 1  OR education_level   = :education_level)
  AND (:job_title_is_all    = 1  OR job_title         = :job_title)
  AND (:department_is_all   = 1  OR department        = :department)
  AND (:state_is_all        = 1  OR state             = :state)
  AND (:city_is_all         = 1  OR city              = :city)
  AND (:status_is_all       = 1
       OR CASE WHEN term_date IS NULL THEN 'Hired' ELSE 'Terminated' END = :status)
  AND (:salary_min IS NULL OR salary::numeric >= :salary_min)
  AND (:salary_max IS NULL OR salary::numeric <= :salary_max)
  AND (:hire_year_is_all    = 1  OR EXTRACT(YEAR FROM hire_date) = :hire_year)
  AND (:term_year_is_all    = 1  OR EXTRACT(YEAR FROM term_date) = :term_year)
  AND (:loe_min IS NULL OR
       CASE
         WHEN term_date IS NULL
           THEN FLOOR((CURRENT_DATE - hire_date) / 365.25)::int
         ELSE   FLOOR((term_date   - hire_date) / 365.25)::int
       END >= :loe_min)
  AND (:loe_max IS NULL OR
       CASE
         WHEN term_date IS NULL
           THEN FLOOR((CURRENT_DATE - hire_date) / 365.25)::int
         ELSE   FLOOR((term_date   - hire_date) / 365.25)::int
       END <= :loe_max)

ORDER BY CONCAT(first_name, ' ', last_name);


-- F1. Distinct Job Titles
SELECT DISTINCT job_title FROM dataset ORDER BY job_title;

-- F2. Distinct Departments
SELECT DISTINCT department FROM dataset ORDER BY department;

-- F3. Distinct States
SELECT DISTINCT state FROM dataset ORDER BY state;

-- F4. Distinct Cities
SELECT DISTINCT city FROM dataset ORDER BY city;
