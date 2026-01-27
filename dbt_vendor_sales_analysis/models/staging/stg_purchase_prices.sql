{{ config(materialized='view') }}

with cte as (
    select
    cast(Brand as string) as Brand,
    cast(Description as string) as Description,
    cast(Price as float64) as Price,
    cast(Size as string) as Size,
    cast(Volume as string) as Volume,
    cast(VendorNumber as string) as VendorNumber,
    cast(VendorName as string) as VendorName,
    cast(PurchasePrice as float64) as PurchasePrice,
    cast(Classification as int64) as Classification

from {{ source('raw', 'purchase_prices') }}

)

select * from cte