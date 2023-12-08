with raw_table as (
    select
        order_id
        , customer_id
        , employee_id
        , order_date
        , required_date
        , shipped_date
        , ship_via
        , cast(freight as numeric) as freight
        , ship_name
        , ship_address
        , ship_city
        , ship_region
        , ship_postal_code
        , ship_country
        , updated_at
        , row_number() over(partition by order_id order by updated_at desc) as index_dedup 

        -- Campos nulos
        -- , string_field_14
    from {{ source('northwind', 'orders_partitioned') }}
)

, dedup as (
    select *
    from raw_table
    where index_dedup = 1
)

select *
from dedup