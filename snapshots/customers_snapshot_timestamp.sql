{% snapshot customers_snapshot_timestamp %}

{{
    config(
        target_database='bv-dbt-treinamento',
        target_schema='snapshots',
        unique_key='customerID',
        strategy='timestamp',
        updated_at='updated_at',
    )
}}

select * from {{ source('northwind', 'customers') }}

{% endsnapshot %}