with source as (
    select * from {{ source('salesforce_raw', 'Contract') }}
),
renamed as (
    select
        * -- TODO: Add specific column selection and cleansing once data is available
    from source
)
select * from renamed
