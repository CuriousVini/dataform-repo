{{
    config(
        materialized = "view"
    )
}}

WITH source AS (
    SELECT * FROM {{ source('salesforce', 'Contract') }}
),

cleansed AS (
    SELECT
        Id AS contract_id,
        AccountId AS customer_id,
        Status AS status,
        -- Assuming BillingPostalCode is available, otherwise adjust to match your schema
        -- or join with Account if that object is also ingested.
        COALESCE(BillingPostalCode, '') AS zip_code,
        PARSE_DATE('%Y-%m-%d', CAST(StartDate AS STRING)) AS start_date,
        PARSE_DATE('%Y-%m-%d', CAST(EndDate AS STRING)) AS end_date,
        TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY) AS load_timestamp
    FROM source
    WHERE Status = 'Activated'
)

SELECT * FROM cleansed
