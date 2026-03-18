with joined_data as (
    select * from {{ ref('active_contracts_joined') }}
),
calculated as (
    select
        *,
        -- Projected CLV: ARPU * 12 (Annualized)
        average_revenue_per_user_arpu * 12 as projected_clv
    from joined_data
),
upsell_target as (
    select *
    from calculated
    where
        is_5g_fwa_eligible = TRUE
        -- Potential upsell targets: Eligible for 5G, but maybe not fully utilized
        -- or high CLV potential.
)
select * from upsell_target
