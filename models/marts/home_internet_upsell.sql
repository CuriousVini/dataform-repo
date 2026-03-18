with joined_data as (
    select * from {{ ref('active_contracts_joined') }}
),
calculated as (
    select
        *,
        -- Proposed CLV: ARPU * 12 (Annualized)
        -- TODO: Verify CLV formula with user
        average_revenue_per_user_arpu * 12 as projected_clv
    from joined_data
),
upsell_target as (
    select *
    from calculated
    where
        is_5g_fwa_eligible = TRUE
        -- Add additional conditions to identify targets
        -- e.g., expected_download_speed_mbps > 100
)
select * from upsell_target
