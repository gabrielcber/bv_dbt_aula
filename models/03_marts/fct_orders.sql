with int_orders as (
    select *
    from {{ ref('int_orders') }}
)

select *
from int_orders