with
contracts as (
    select * from {{ ref('stg_salesforce__contracts') }}
),
billing as (
    select * from {{ source('5g_billing_dataset', 'fct_monthly_billing') }}
),
serviceability as (
    select * from {{ source('5g_billing_dataset', 'dim_network_serviceability') }}
)

select
    c.contract_id,
    c.customer_id,
    c.zip_code,
    c.contract_term,
    b.monthly_recurring_charge_mrc as mrc,
    b.average_revenue_per_user_arpu as arpu,
    (c.contract_term * b.monthly_recurring_charge_mrc) as projected_clv,
    s.is_5g_fwa_eligible,
    s.expected_download_speed_mbps
from contracts c
join billing b
    on c.customer_id = b.customer_id
join serviceability s
    on c.zip_code = s.zip_code
where s.is_5g_fwa_eligible = true
