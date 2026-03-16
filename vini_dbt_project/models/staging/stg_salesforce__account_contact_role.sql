with source as (
    select * from {{ source('salesforce', 'AccountContactRole') }}
),
cleansed as (
    select
        Id as account_contact_role_id,
        AccountId as account_id,
        ContactId as contact_id,
        Role as role,
        IsPrimary as is_primary,
        CreatedDate as created_at,
        LastModifiedDate as last_modified_at,
        SystemModstamp as system_modstamp
    from source
    where not IsDeleted
)
select * from cleansed
