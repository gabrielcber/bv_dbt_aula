{{
    config(
        materialized = 'view'
    )
}}

with raw_table as (
    select
        orderID as order_id
        , productID as product_id
        , cast(unitPrice as numeric) as unit_price
        , quantity
        , cast(discount as numeric) as discount
    from {{ source('northwind', 'order_details') }}
)

select *
from raw_table