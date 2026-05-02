/*
  I1. Berapa rentang gaji (min, avg, max) berdasarkan Education Level dan Gender?
  - Digunakan untuk lollipop / range chart
  - Titik tengah = avg_salary
*/
SELECT
  education_level,
  gender,
  MIN(salary::numeric)            AS min_salary,
  ROUND(AVG(salary::numeric), 0)  AS avg_salary,
  MAX(salary::numeric)            AS max_salary
FROM dataset
GROUP BY education_level, gender
ORDER BY education_level, gender;

/*
RESULTS
=======
| education_level | gender | min_salary | avg_salary | max_salary |
|-----------------|--------|------------|------------|------------|
| Bachelor        | Female | 45000      | 71432      | 120000     |
| Bachelor        | Male   | 45000      | 73810      | 120000     |
| High School     | Female | 45000      | 59823      | 100000     |
| High School     | Male   | 45000      | 60741      | 102000     |
| Master          | Female | 50000      | 81205      | 130000     |
| Master          | Male   | 50000      | 83490      | 130000     |
| PhD             | Female | 55000      | 93214      | 150000     |
| PhD             | Male   | 55000      | 80312      | 145000     |
*/


/*
  I2. Bagaimana hubungan antara usia dan gaji karyawan?
  - Setiap titik = satu karyawan; job_title ditampilkan saat hover
*/
SELECT
  employee_id,
  CONCAT(first_name, ' ', last_name) AS employee_name,
  EXTRACT(YEAR FROM AGE(
    CURRENT_DATE, birthdate ))::int AS age,
  salary::numeric AS salary,
  job_title
FROM dataset
WHERE birthdate IS NOT NULL
  AND salary    IS NOT NULL
ORDER BY age;

/*
RESULTS (sample)
=======
| employee_id | employee_name   | age | salary | job_title                |
|-------------|-----------------|-----|--------|--------------------------|
| 00-11223344 | Emma Davis      | 22  | 55000  | HR Assistant             |
| 00-55667788 | James Wilson    | 23  | 58500  | Support Specialist       |
| ...         | ...             | ... | ...    | ...                      |
| 00-99887766 | Robert Chen     | 48  | 115000 | Finance Manager          |
| 00-44332211 | Sarah Martinez  | 51  | 120000 | IT Manager               |
*/
