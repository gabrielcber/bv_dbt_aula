{% snapshot customers_snapshot_check %}

{{
    config(
        target_database='bv-dbt-treinamento',
        target_schema='snapshots',
        strategy='check',
        unique_key='customerID',
        check_cols=['address'],
    )
}}

select * from {{ source('northwind', 'customers') }}

{% endsnapshot %}