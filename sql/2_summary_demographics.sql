/*
  D1. Bagaimana distribusi gender secara keseluruhan?
  - Tampilkan jumlah dan persentase tiap gender
*/
SELECT
  gender,
  COUNT(*)                                               AS employee_count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)    AS pct_of_total
FROM dataset
GROUP BY gender
ORDER BY employee_count DESC;

/*
RESULTS
=======
| gender | employee_count | pct_of_total |
|--------|----------------|--------------|
| Male   | 4833           | 54.00        |
| Female | 4117           | 46.00        |
*/


/*
  D2. Bagaimana distribusi gender berdasarkan status karyawan?
  - Sumber data untuk dual donut chart (Female & Male)
  - Label 'Hired' (bukan 'Active') agar Tableau cross-filter bekerja
*/
SELECT
  gender,
  CASE
    WHEN termdate IS NULL THEN 'Hired'
    ELSE 'Terminated'
  END                 AS employee_status,
  COUNT(*)            AS employee_count
FROM dataset
GROUP BY
  gender,
  CASE WHEN termdate IS NULL THEN 'Hired' ELSE 'Terminated' END
ORDER BY gender, employee_status;

/*
RESULTS
=======
| gender | employee_status | employee_count |
|--------|-----------------|----------------|
| Female | Hired           | 3665           |
| Female | Terminated      | 452            |
| Male   | Hired           | 4319           |
| Male   | Terminated      | 514            |
*/


/*
  D3. Bagaimana distribusi karyawan berdasarkan Education Level dan Age Group?
  - Ukuran bubble merepresentasikan jumlah karyawan di tiap sel
  - ORDER BY menggunakan CASE eksplisit karena '<25' (ASCII 60) akan
    salah urut setelah '55+' (ASCII 53) jika diurutkan secara string
*/
SELECT
  age_group,
  education_level,
  COUNT(*) AS employee_count
FROM (
  SELECT
    education_level,
    CASE
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) < 25              THEN '<25'
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) BETWEEN 25 AND 34 THEN '25-34'
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) BETWEEN 35 AND 44 THEN '35-44'
      WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) BETWEEN 45 AND 54 THEN '45-54'
      ELSE '55+'
    END AS age_group
  FROM dataset
) sub
GROUP BY age_group, education_level
ORDER BY
  CASE age_group
    WHEN '<25'   THEN 1
    WHEN '25-34' THEN 2
    WHEN '35-44' THEN 3
    WHEN '45-54' THEN 4
    WHEN '55+'   THEN 5
  END,
  education_level;

/*
RESULTS (sample)
=======
| age_group | education_level | employee_count |
|-----------|-----------------|----------------|
| <25       | Bachelor        | 98             |
| <25       | High School     | 142            |
| <25       | Master          | 41             |
| 25-34     | Bachelor        | 1876           |
| 25-34     | High School     | 1243           |
| ...       | ...             | ...            |
*/


/*
  D4. Bagaimana distribusi Performance Rating berdasarkan Education Level?
  - Intensitas warna merepresentasikan jumlah karyawan per sel (heat map)
*/
SELECT
  education_level,
  performance_rating,
  COUNT(*) AS employee_count
FROM dataset
GROUP BY education_level, performance_rating
ORDER BY education_level, performance_rating;

/*
RESULTS
=======
| education_level | performance_rating   | employee_count |
|-----------------|----------------------|----------------|
| Bachelor        | Excellent            | 621            |
| Bachelor        | Good                 | 1489           |
| Bachelor        | Needs Improvement    | 412            |
| Bachelor        | Satisfactory         | 953            |
| High School     | Excellent            | 487            |
| High School     | Good                 | 1102           |
| ...             | ...                  | ...            |
*/
