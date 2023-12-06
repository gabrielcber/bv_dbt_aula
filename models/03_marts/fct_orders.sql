{{
    config(
        materialized = 'incremental'
        , unique_key = 'order_sk'
    )
}}

with int_orders as (
    select *
    from {{ ref('int_orders') }}
)

, dim_customers as (
    select *
    from {{ ref('dim_customers') }}
)

, joining as (
    select
        {{ dbt_utils.generate_surrogate_key(['orders.order_id']) }} as order_sk
        , customers.customer_sk as customer_fk
        , orders.order_id
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
        , orders.product_id
        , orders.unit_price
        , orders.quantity
        , orders.discount
        , orders.updated_at
    from int_orders as orders
    left join dim_customers as customers on
        orders.customer_id = customers.customer_id
)

select *
from joining

{% if is_incremental() %}

    -- this filter will only be applied on an incremental run
    -- (uses > to include records whose timestamp occurred since the last run of this model)
    where updated_at > (select max(updated_at) from {{ this }})

{% endif %}