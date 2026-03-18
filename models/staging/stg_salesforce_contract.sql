select
    Id as contract_id,
    AccountId as customer_id,
    Status as status,
    StartDate as start_date,
    EndDate as end_date,
    ContractTerm as term_months,
    BillingPostalCode as zip_code
from {{ source('salesforce', 'Contract') }}
where Status = 'Draft' or Status = 'Activated' -- Active filter to be refined
