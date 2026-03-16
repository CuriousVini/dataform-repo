with source as (
    select * from {{ source('salesforce', 'AccountFeed') }}
),
cleansed as (
    select
        Id as account_feed_id,
        ParentId as parent_id,
        Type as feed_type,
        Title as title,
        Body as body,
        CommentCount as comment_count,
        LikeCount as like_count,
        IsRichText as is_rich_text,
        CreatedDate as created_at,
        CreatedById as created_by_id,
        LastModifiedDate as last_modified_at,
        SystemModstamp as system_modstamp
    from source
    where not IsDeleted
)
select * from cleansed
