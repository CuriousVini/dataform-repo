{{
    config(
        materialized = "table"
    )
}}

WITH contracts AS (
    SELECT * FROM {{ ref('stg_salesforce_contract') }}
),

billing AS (
    SELECT * FROM {{ source('billing', 'fct_monthly_billing') }}
),

coverage AS (
    SELECT * FROM {{ source('billing', 'dim_network_serviceability') }}
),

joined AS (
    SELECT
        c.customer_id,
        c.contract_id,
        c.zip_code,
        b.monthly_recurring_charge_mrc,
        b.average_revenue_per_user_arpu,
        cov.is_5g_fwa_eligible,
        cov.local_cell_tower_id,
        cov.tower_utilization_pct,
        cov.expected_download_speed_mbps,
        
        -- Projected CLV Calculation
        -- Assumed Formula: Monthly MRC * 12 (Annualized)
        (b.monthly_recurring_charge_mrc * 12) AS projected_clv_annual,
        
        CURRENT_TIMESTAMP() AS created_at
    FROM contracts c
    INNER JOIN billing b ON c.customer_id = b.customer_id
    INNER JOIN coverage cov ON c.zip_code = cov.zip_code
    WHERE cov.is_5g_fwa_eligible = TRUE
)

SELECT * FROM joined
