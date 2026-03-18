with contracts as (
    select * from {{ ref('stg_salesforce__contract') }}
),
billing as (
    select * from {{ source('5g_billing_dataset', 'fct_monthly_billing') }}
),
coverage as (
    select * from {{ source('5g_billing_dataset', 'dim_network_serviceability') }}
),
joined as (
    select
        c.contract_id,
        c.customer_id,
        c.status as contract_status,
        c.start_date,
        c.end_date,
        c.contract_term,
        b.monthly_recurring_charge_mrc,
        b.average_revenue_per_user_arpu,
        b.late_payment_flag,
        b.autopay_enrolled,
        cov.zip_code,
        cov.is_5g_fwa_eligible,
        cov.local_cell_tower_id,
        cov.tower_utilization_pct,
        cov.expected_download_speed_mbps
    from contracts c
    left join billing b on c.customer_id = b.customer_id 
    left join coverage cov on c.zip_code = cov.zip_code
)
select * from joined
