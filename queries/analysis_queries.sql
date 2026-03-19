-- =====================================================
-- 1. LOAN STATUS DISTRIBUTION
-- =====================================================
WITH total_loans AS (
  SELECT
    COUNT(*) AS total_loans
  FROM fintech_loans
),

total_loans_per_status AS (
  SELECT
    status,
    COUNT(*) AS total_loans_per_status
  FROM fintech_loans
  GROUP BY status
  ORDER BY total_loans_per_status DESC
)

SELECT
  status,
  total_loans_per_status,
  ROUND((total_loans_per_status/total_loans) * 100, 2) AS loan_status_distribution
FROM total_loans_per_status, total_loans
ORDER BY loan_status_distribution DESC;

-- =====================================================
-- 2. DEFAULT RATE BY AGE
-- =====================================================
WITH age_ranges AS (
  SELECT
    CASE
      WHEN age BETWEEN 18 AND 25 THEN '18-25'
      WHEN age BETWEEN 26 AND 35 THEN '26-35'
      WHEN age BETWEEN 36 AND 45 THEN '36-45'
      WHEN age BETWEEN 46 AND 59 THEN '46-59'
    END AS age_range,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN l.status = 'default' THEN 1 ELSE 0 END) AS default_loans
  FROM fintech_users u
  LEFT JOIN fintech_loans l
    ON u.user_id = l.user_id
  GROUP BY age_range
)

SELECT
  age_range,
  total_loans,
  default_loans,
  ROUND(default_loans * 100 / total_loans, 2) AS default_rate
FROM age_ranges
ORDER BY age_range ASC;

-- =====================================================
-- 3. DEFAULT RATE BY ACQUISITION CHANNEL
-- =====================================================
SELECT
  u.acquisition_channel,
  COUNT(*) AS total_loans,
  SUM(CASE WHEN l.status = 'default' THEN 1 ELSE 0 END) AS default_loans,
  ROUND(SUM(CASE WHEN l.status = 'default' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS default_rate
FROM fintech_users u
LEFT JOIN fintech_loans l
  ON u.user_id = l.user_id
GROUP BY acquisition_channel;

-- =====================================================
-- 4. DEFAULT RATE BY COUNTRY
-- =====================================================
SELECT
  u.country,
  COUNT(*) AS total_loans,
  SUM(CASE WHEN l.status = 'default' THEN 1 ELSE 0 END) AS default_loans,
  ROUND(SUM(CASE WHEN l.status = 'default' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS default_rate
FROM fintech_users u
LEFT JOIN fintech_loans l
  ON u.user_id = l.user_id
GROUP BY country;

-- =====================================================
-- 5. TIME TO FIRST PAYMENT
-- =====================================================
WITH valid_payments AS (
  SELECT
    l.loan_id,
    l.user_id,
    l.disbursed_at,
    t.transaction_date AS payment_date
  FROM fintech_loans l
  LEFT JOIN fintech_transactions t
    ON l.loan_id = t.loan_id
  WHERE t.transaction_type = 'payment' AND t.transaction_date >= l.disbursed_at
),

first_payment_per_loan AS (
  SELECT
    loan_id,
    user_id,
    disbursed_at,
    MIN(payment_date) AS first_payment_date
  FROM valid_payments
  GROUP BY loan_id, user_id, disbursed_at
),

days_to_first_payment AS (
  SELECT
    loan_id,
    user_id,
    datediff(first_payment_date, disbursed_at) AS days_to_first_payment
  FROM first_payment_per_loan
)

SELECT
  CASE
    WHEN days_to_first_payment = 0 THEN '1. 0 days'
    WHEN days_to_first_payment BETWEEN 1 AND 7 THEN '2. 1-7 days'
    WHEN days_to_first_payment BETWEEN 8 AND 30 THEN '3. 8-30 days'
    WHEN days_to_first_payment BETWEEN 31 AND 90 THEN '4. 31-90 days'
    WHEN days_to_first_payment BETWEEN 91 AND 180 THEN '5. 91-180 days'
    WHEN days_to_first_payment BETWEEN 181 AND 365 THEN '6. 181-365 days'
    WHEN days_to_first_payment BETWEEN 366 AND 719 THEN '7. 366-719 days'
  END AS days_to_first_payment_range,
  COUNT(*) AS loans
FROM days_to_first_payment
GROUP BY days_to_first_payment_range
ORDER BY days_to_first_payment_range;

-- =====================================================
-- 6. REPEAT BORROWERS (USERS WITH > 3 LOANS)
-- =====================================================
SELECT
  user_id,
  COUNT(DISTINCT(loan_id)) AS loans
FROM fintech_loans
GROUP BY user_id
HAVING loans > 3
ORDER BY loans DESC;

-- =====================================================
-- 7. DEFAULTED LOANS BY REPEAT BORROWERS
-- =====================================================
WITH users_with_many_loans AS (
  SELECT
    user_id,
    COUNT(DISTINCT loan_id) AS loans
  FROM fintech_loans
  GROUP BY user_id
  HAVING COUNT(DISTINCT loan_id) > 3
)

SELECT
  l.user_id,
  COUNT(DISTINCT l.loan_id) AS total_loans,
  SUM(CASE WHEN l.status = 'default' THEN 1 ELSE 0 END) AS default_loans
FROM fintech_loans l
JOIN users_with_many_loans u
  ON l.user_id = u.user_id
GROUP BY l.user_id
ORDER BY default_loans DESC;
