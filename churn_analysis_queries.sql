CREATE TABLE churn_raw (
    customer_id TEXT,
    tenure TEXT,
    phone_service TEXT,
    contract TEXT,
    paperless_billing TEXT,
    payment_method TEXT,
    monthly_charges TEXT,
    total_charges TEXT,
    churn TEXT
);


SELECT * FROM churn_raw LIMIT 10;


SELECT COUNT(*) FROM churn_raw;


SELECT COUNT(*)
FROM churn_raw
WHERE total_charges = '';


CREATE TABLE churn AS
SELECT
    customer_id,
    tenure::INT,
    phone_service::BOOLEAN,
    contract,
    paperless_billing::BOOLEAN,
    payment_method,
    monthly_charges::NUMERIC,
    NULLIF(total_charges, '')::NUMERIC,
    churn::BOOLEAN
FROM churn_raw;


SELECT COUNT(*) FROM churn;


SELECT
  MIN(tenure) AS min_tenure,
  MAX(tenure) AS max_tenure,
  MIN(monthly_charges) AS min_monthly,
  MAX(monthly_charges) AS max_monthly
FROM churn;

SELECT DISTINCT contract FROM churn;
SELECT DISTINCT payment_method FROM churn;
SELECT DISTINCT phone_service FROM churn;
SELECT DISTINCT churn FROM churn;


SELECT COUNT(*)
FROM churn
WHERE tenure = 0 AND total_charges <> 0;


SELECT
  percentile_cont(0.99) WITHIN GROUP (ORDER BY monthly_charges) AS p99_monthly
FROM churn;


SELECT
  Churn,
  COUNT(*) AS customer_count,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM churn), 2) AS churn_percentage
FROM churn
GROUP BY Churn;


SELECT
  SUM(monthly_charges) AS monthly_revenue_lost
FROM churn
WHERE Churn = 'true';

SELECT * FROM churn


SELECT
  SUM(total_charges) AS lifetime_revenue_lost
FROM churn
WHERE churn = 'Yes';


SELECT
  CASE
    WHEN tenure <= 6 THEN '0–6 months'
    WHEN tenure <= 24 THEN '7–24 months'
    ELSE '25+ months'
  END AS tenure_group,
  COUNT(*) AS total_customers,
  COUNT(*) FILTER (WHERE churn = 'Yes') AS churned_customers,
  ROUND(
    100.0 * COUNT(*) FILTER (WHERE churn = 'Yes') / COUNT(*),
    2
  ) AS churn_rate
FROM churn
GROUP BY tenure_group
ORDER BY churn_rate DESC;


SELECT
  contract,
  COUNT(*) AS total_customers,
  COUNT(*) FILTER (WHERE churn = 'Yes') AS churned,
  ROUND(
    100.0 * COUNT(*) FILTER (WHERE churn = 'Yes') / COUNT(*),
    2
  ) AS churn_rate
FROM churn
GROUP BY contract
ORDER BY churn_rate DESC;


SELECT
  payment_method,
  ROUND(
    100.0 * COUNT(*) FILTER (WHERE churn = 'Yes') / COUNT(*),
    2
  ) AS churn_rate
FROM churn
GROUP BY payment_method
ORDER BY churn_rate DESC;


SELECT
  churn,
  AVG(monthly_charges) AS avg_monthly_revenue,
  AVG(total_charges) AS avg_lifetime_value
FROM churn
GROUP BY churn;


CREATE VIEW churn_analysis_base AS
SELECT
  customer_id,
  tenure,
  phone_service,
  contract,
  paperless_billing,
  payment_method,
  monthly_charges,
  total_charges,
  churn
FROM churn;


SELECT * FROM churn


