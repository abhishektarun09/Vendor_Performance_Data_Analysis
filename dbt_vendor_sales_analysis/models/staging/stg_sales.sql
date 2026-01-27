{{ config(materialized='view') }}

with cte as (
    select
    cast(InventoryId as string) as InventoryId,
    cast(Store as string) as Store,
    cast(Brand as string) as Brand,
    cast(Description as string) as Description,
    cast(Size as string) as Size,
    cast(SalesQuantity as int64) as SalesQuantity,
    cast(SalesDollars as float64) as SalesDollars,
    cast(SalesPrice as float64) as SalesPrice,
    cast(SalesDate as date) as SalesDate,
    cast(Volume as float64) as Volume,
    cast(Classification as int64) as Classification,
    cast(ExciseTax as float64) as ExciseTax,
    cast(VendorNo as string) as VendorNo,
    cast(VendorName as string) as VendorName
    from {{ source('raw', 'sales') }}

)

select * from cte