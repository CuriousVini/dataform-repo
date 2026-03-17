with source as (
    select * from {{ source('salesforce_ingest', 'Contract') }}
),
renamed as (
    select
        Id as contract_id,
        AccountId as customer_id,
        BillingPostalCode as zip_code,
        ContractTerm as contract_term,
        Status as status,
        IsDeleted as is_deleted,
        CreatedDate as created_date
    from source
)
select * from renamed
where is_deleted = false
