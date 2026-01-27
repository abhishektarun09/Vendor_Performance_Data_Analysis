{{ config(materialized='view') }}

with cte as (
    select
    cast(VendorNumber as string) as VendorNumber,
    trim(cast(VendorName as STRING)) as VendorName,
    cast(InvoiceDate as date) as InvoiceDate,
    cast(PONumber as string) as PONumber,
    cast(PODate as date) as PODate,
    cast(PayDate as date) as PayDate,
    cast(Quantity as int64) as Quantity,
    cast(Dollars as float64) as Dollars,
    cast(Freight as float64) as Freight
from {{ source('raw', 'vendor_invoice') }}

)

select * from cte