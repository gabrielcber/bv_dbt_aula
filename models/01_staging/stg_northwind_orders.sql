with raw_table as (
    select
        orderID as order_id
        , customerID as customer_id
        , employeeID as employee_id
        , orderDate as order_date
        , requiredDate as required_date
        , shippedDate as shipped_date
        , shipVia as ship_via
        , cast(freight as numeric) as freight
        , shipName as ship_name
        , shipAddress as ship_address
        , shipCity as ship_city
        , shipRegion as ship_region
        , shipPostalCode as ship_postal_code
        , shipCountry as ship_country
        , updated_at
        , row_number() over(partition by orderID order by updated_at desc) as index_dedup 

        -- Campos nulos
        -- , string_field_14
    from {{ source('northwind', 'orders') }}
)

, dedup as (
    select *
    from raw_table
    where index_dedup = 1
)

select *
from dedup