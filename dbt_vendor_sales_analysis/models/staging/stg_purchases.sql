{{ config(materialized='view') }}

with cte as (
    select
    cast(InventoryId as string) as InventoryId,
    cast(Store as string) as Store,
    cast(Brand as string) as Brand,
    cast(Description as string) as Description,
    cast(Size as string) as Size,
    cast(VendorNumber as string) as VendorNumber,
    cast(VendorName as string) as VendorName,
    cast(PONumber as string) as PONumber,
    cast(PODate as date) as PODate,
    cast(ReceivingDate as date) as ReceivingDate,
    cast(InvoiceDate as date) as InvoiceDate,
    cast(PayDate as date) as PayDate,
    cast(PurchasePrice as float64) as PurchasePrice,
    cast(Quantity as int64) as Quantity,
    cast(Dollars as float64) as Dollars,
    cast(Classification as int64) as Classification
from {{ source('raw', 'purchases') }}

)

select * from cte