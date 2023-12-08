{{ 
    config(
        materialized = 'incremental'
        , incremental_strategy = 'insert_overwrite'
        , partitions = var('today_and_yesterday')
        , partition_by = {
            'field': 'updated_at'
            , 'data_type': 'timestamp'
            , 'granularity': 'day'
        }
        , on_schema_change = 'fail'
    )
}}

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
        {{ dbt_utils.generate_surrogate_key(['orders.order_id', 'order_details.product_id']) }} as order_sk
        , orders.order_id
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
        , orders.updated_at
    from order_details
    left join orders on order_details.order_id = orders.order_id
)

select *
from joining

{% if is_incremental() %}

    -- this filter will only be applied on an incremental run
    -- (uses > to include records whose timestamp occurred since the last run of this model)
    -- where updated_at > (select max(updated_at) from {{ this }}) -- Dinamico

    -- where extract(date from updated_at) = current_date() -- Estático

    where extract(date from updated_at) in ({{ var('today_and_yesterday') | join(',') }}) -- Estático

{% endif %}