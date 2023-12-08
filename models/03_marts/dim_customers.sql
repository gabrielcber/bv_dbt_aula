with staging as (
    select
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_sk
        , *
        , asfasf
    from {{ ref('stg_northwind_customers') }}
)

select *
from staging
