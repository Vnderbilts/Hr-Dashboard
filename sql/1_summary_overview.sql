/*
  O1. Berapa jumlah karyawan yang masih aktif (Hired)?
  - Hitung karyawan dengan termdate kosong/NULL
*/
SELECT COUNT(*) AS active_employee
FROM dataset
WHERE NULLIF(termdate, '') IS NULL;

/*
RESULTS
=======
| active_employee |
|-----------------|
| 7984            |
*/


/*
  O2. Berapa total karyawan yang pernah direkrut?
*/
SELECT COUNT(*) AS total_hired
FROM dataset;

/*
RESULTS
=======
| total_hired |
|-------------|
| 8950        |
*/


/*
  O3. Berapa total karyawan yang sudah di-terminasi?
*/
SELECT COUNT(*) AS total_terminated
FROM dataset
WHERE termdate IS NOT NULL;

/*
RESULTS
=======
| total_terminated |
|------------------|
| 966              |
*/


/*
  O4. Berapa jumlah karyawan yang direkrut per bulan?
  - Digunakan untuk trend line hiring (warna emas)
*/
SELECT
  DATE_TRUNC('month', hiredate)::date AS month_start,
  COUNT(*) AS hired_count
FROM dataset
GROUP BY 1
ORDER BY 1;

/*
RESULTS (sample)
=======
| month_start | hired_count |
|-------------|-------------|
| 2015-01-01  | 58          |
| 2015-02-01  | 72          |
| 2015-03-01  | 65          |
| ...         | ...         |
*/


/*
  O5. Berapa jumlah karyawan yang di-terminasi per bulan?
  - Digunakan untuk trend line terminasi (warna merah)
*/
SELECT
  DATE_TRUNC('month', termdate)::date  AS month_start,
  COUNT(*) AS terminated_count
FROM dataset
WHERE termdate IS NOT NULL
GROUP BY 1
ORDER BY 1;

/*
RESULTS (sample)
=======
| month_start | terminated_count |
|-------------|------------------|
| 2015-06-01  | 4                |
| 2015-07-01  | 6                |
| 2015-08-01  | 5                |
| ...         | ...              |
*/


/*
  O6. Berapa jumlah karyawan aktif dan terminasi per departemen?
  - Digunakan untuk stacked bar chart horizontal
*/
SELECT
  department,
  SUM(CASE WHEN termdate IS NULL     THEN 1 ELSE 0 END) AS hired_count,
  SUM(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) AS terminated_count,
  COUNT(*)                                                           AS total_count
FROM dataset
GROUP BY department
ORDER BY total_count DESC;

/*
RESULTS
=======
| department        | hired_count | terminated_count | total_count |
|-------------------|-------------|------------------|-------------|
| Operations        | 2429        | 289              | 2718        |
| Sales             | 1624        | 182              | 1806        |
| Customer Service  | 1294        | 145              | 1439        |
| IT                | 1098        | 121              | 1219        |
| Finance           | 864         | 98               | 962         |
| Marketing         | 432         | 82               | 514         |
| HR                | 243         | 49               | 292         |
*/


/*
  O7. Berapa jumlah karyawan per state?
  - Digunakan untuk filled map dan bar chart lokasi
*/
SELECT
  state,
  COUNT(*) AS employee_count
FROM dataset
GROUP BY state
ORDER BY employee_count DESC;

/*
RESULTS (sample)
=======
| state          | employee_count |
|----------------|----------------|
| New York       | 3025           |
| Pennsylvania   | 1843           |
| Ohio           | 1102           |
| Illinois       | 897            |
| Michigan       | 742            |
| ...            | ...            |
*/
