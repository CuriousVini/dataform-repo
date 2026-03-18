with source as (
    select * from {{ source('salesforce_raw', 'Contract') }}
),
cleansed as (
    select
        Id as contract_id,
        AccountId as customer_id, -- Mapped to customer_id for easier join
        Status as status,
        StartDate as start_date,
        EndDate as end_date,
        TRIM(BillingPostalCode) as zip_code,
        ContractTerm as contract_term
    from source
    where Status = 'Activated'
)
select * from cleansed
