WITH contract AS (
    SELECT * FROM {{ ref('stg_salesforce_contract') }}
),
billing AS (
    SELECT * FROM {{ source('5g_billing_dataset', 'fct_monthly_billing') }}
),
coverage AS (
    SELECT * FROM {{ source('5g_billing_dataset', 'dim_network_serviceability') }}
),
contract_billing AS (
    SELECT
        c.contract_id,
        c.customer_id,
        c.zip_code,
        c.contract_status,
        c.contract_term_months,
        COALESCE(c.contract_end_date, b.contract_end_date) AS end_date,
        b.monthly_recurring_charge_mrc,
        b.average_revenue_per_user_arpu,
        b.late_payment_flag,
        b.autopay_enrolled
    FROM contract c
    INNER JOIN billing b ON c.customer_id = b.customer_id
),
eligible_customers AS (
    SELECT
        cb.*,
        cov.is_5g_fwa_eligible,
        cov.local_cell_tower_id,
        cov.tower_utilization_pct,
        cov.expected_download_speed_mbps
    FROM contract_billing cb
    INNER JOIN coverage cov ON cb.zip_code = cov.zip_code
    WHERE cov.is_5g_fwa_eligible = TRUE
),
final AS (
    SELECT
        *,
        (average_revenue_per_user_arpu * GREATEST(0, DATE_DIFF(CAST(end_date AS DATE), CURRENT_DATE(), MONTH))) AS projected_clv
    FROM eligible_customers
)
SELECT * FROM final
