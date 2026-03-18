with contracts as (
    select * from {{ ref('stg_salesforce__contract') }}
    -- TODO: Filter for active contracts (e.g., where status = 'Activated')
),
billing as (
    select * from {{ source('5g_billing_dataset', 'fct_monthly_billing') }}
),
coverage as (
    select * from {{ source('5g_billing_dataset', 'dim_network_serviceability') }}
),
joined as (
    select
        -- Salesforce fields
        c.*,
        -- Billing fields
        b.monthly_recurring_charge_mrc,
        b.average_revenue_per_user_arpu,
        b.late_payment_flag,
        b.autopay_enrolled,
        b.contract_end_date,
        -- Coverage fields
        cov.zip_code,
        cov.is_5g_fwa_eligible,
        cov.local_cell_tower_id,
        cov.tower_utilization_pct,
        cov.expected_download_speed_mbps
    from contracts c
    -- TODO: Define correct join keys once Salesforce schema is visible
    left join billing b on c.customer_id = b.customer_id 
    left join coverage cov on c.zip_code = cov.zip_code
)
select * from joined
