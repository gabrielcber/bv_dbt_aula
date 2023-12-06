with raw_table as (
    select
        customerid as customer_id
        , companyName as customer_company_name
        , contactName as customer_contact_name
        , contactTitle as customer_contact_title
        , address as customer_address
        , city as customer_city
        , region as customer_region
        , postalCode as customer_postal_code
        , country as customer_country
        , phone as customer_phone
        , fax as customer_fax
        , updated_at
    from {{ source('northwind', 'customers') }}
)

select *
from raw_table