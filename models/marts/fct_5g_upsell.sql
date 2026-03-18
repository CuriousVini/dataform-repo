with active_contracts as (
    select
        contract_id,
        customer_id,
        status,
        start_date,
        end_date,
        term_months,
        zip_code
    from {{ ref('stg_salesforce_contract') }}
    where status = 'Activated' -- Assuming 'Activated' means active
),

billing_info as (
    select
        customer_id,
        monthly_recurring_charge_mrc as monthly_spend,
        average_revenue_per_user_arpu as arpu,
        autopay_enrolled
    from {{ source('billing', 'fct_monthly_billing') }}
),

serviceability as (
    select
        zip_code,
        is_5g_fwa_eligible,
        tower_utilization_pct,
        expected_download_speed_mbps
    from {{ source('billing', 'dim_network_serviceability') }}
)

select
    c.customer_id,
    c.contract_id,
    c.zip_code,
    b.monthly_spend,
    b.arpu,
    c.term_months,
    -- CLV Calculation: Monthly Spend * Term Months
    (b.monthly_spend * c.term_months) as projected_clv,
    s.is_5g_fwa_eligible,
    s.expected_download_speed_mbps
from active_contracts c
left join billing_info b on c.customer_id = b.customer_id
left join serviceability s on c.zip_code = s.zip_code
where s.is_5g_fwa_eligible = true
order by projected_clv desc
