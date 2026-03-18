{{ config(materialized='table') }}

WITH staging AS (
    SELECT *
    FROM {{ ref('stg_salesforce_contracts') }}
)

SELECT
    contract_id,
    customer_id,
    start_date,
    end_date,
    zip_code
FROM staging
WHERE status = 'Activated'
