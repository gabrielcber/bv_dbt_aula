{% snapshot customers_snapshot_check %}

{{
    config(
        target_database='bv-dbt-treinamento',
        target_schema='snapshots',
        strategy='check',
        unique_key='customerID',
        check_cols=[
            'companyName'
            , 'contactName'
            , 'contactTitle'
            , 'address'
            , 'city'
            , 'region'
            , 'postalCode'
            , 'country'
        ]
    )
}}

select * from {{ source('northwind', 'customers') }}

{% endsnapshot %}