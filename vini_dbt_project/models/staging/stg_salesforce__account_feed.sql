with source as (
    select * from {{ source('salesforce', 'AccountFeed') }}
),
cleansed as (
    select
        Id as account_feed_id,
        ParentId as parent_id,
        Type as feed_type,
        CreatedDate as created_at,
        CreatedById as created_by_id
        -- Add other fields as needed
    from source
)
select * from cleansed
