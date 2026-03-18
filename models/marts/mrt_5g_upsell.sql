{{ config(materialized='table') }}

WITH active_contracts AS (
    SELECT * FROM {{ ref('int_active_contracts') }}
),
billing AS (
    SELECT * FROM {{ source('billing_5g', 'fct_monthly_billing') }}
),
network AS (
    SELECT * FROM {{ source('billing_5g', 'dim_network_serviceability') }}
)

SELECT
    c.contract_id,
    c.customer_id,
    c.zip_code,
    b.average_revenue_per_user_arpu AS arpu,
    DATE_DIFF(b.contract_end_date, CURRENT_DATE(), MONTH) AS remaining_months,
    (b.average_revenue_per_user_arpu * DATE_DIFF(b.contract_end_date, CURRENT_DATE(), MONTH)) AS projected_clv,
    n.is_5g_fwa_eligible,
    n.expected_download_speed_mbps
FROM active_contracts c
JOIN billing b ON c.customer_id = b.customer_id
JOIN network n ON c.zip_code = n.zip_code
WHERE n.is_5g_fwa_eligible = TRUE
