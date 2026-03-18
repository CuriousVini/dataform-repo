{{ config(materialized='view') }}

WITH raw_contracts AS (
    SELECT *
    FROM {{ source('salesforce_raw', 'Contract') }}
)

SELECT
    Id AS contract_id,
    AccountId AS customer_id,
    SAFE_CAST(StartDate AS DATE) AS start_date,
    SAFE_CAST(EndDate AS DATE) AS end_date,
    COALESCE(StatusCode, Status) AS status,
    -- Data Autocleaning: normalize Zip Code
    SUBSTR(TRIM(BillingPostalCode), 1, 5) AS zip_code
FROM raw_contracts
WHERE Id IS NOT NULL
  AND AccountId IS NOT NULL
