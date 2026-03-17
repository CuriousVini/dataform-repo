WITH source AS (
    SELECT * FROM {{ source('salesforce', 'Contract') }}
),
renamed AS (
    SELECT
        Id AS contract_id,
        AccountId AS customer_id,
        BillingPostalCode AS zip_code,
        Status AS contract_status,
        CAST(ContractTerm AS INT64) AS contract_term_months,
        CAST(StartDate AS DATE) AS contract_start_date,
        CAST(EndDate AS DATE) AS contract_end_date
    FROM source
)
SELECT * FROM renamed
