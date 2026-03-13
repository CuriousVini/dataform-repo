with source as (
    select * from {{ source('salesforce', 'AccountContactRole') }}
),
cleansed as (
    select
        Id as account_contact_role_id,
        AccountId as account_id,
        ContactId as contact_id,
        Role as role,
        CreatedDate as created_at
        -- Add other fields as needed
    from source
)
select * from cleansed
