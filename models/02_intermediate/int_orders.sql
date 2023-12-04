with orders as (
    select *
    from {{ ref('stg_northwind_orders') }}
)

, order_details as (
    select *
    from {{ ref('stg_northwind_order_details') }}
)

, joining as (
    select
        orders.order_id
        , orders.customer_id
        , orders.employee_id
        , orders.order_date
        , orders.required_date
        , orders.shipped_date
        , orders.ship_via
        , orders.freight
        , orders.ship_name
        , orders.ship_address
        , orders.ship_city
        , orders.ship_region
        , orders.ship_postal_code
        , orders.ship_country
        , order_details.product_id
        , order_details.unit_price
        , order_details.quantity
        , order_details.discount
    from order_details
    left join orders on order_details.order_id = orders.order_id
)

select *
from joining