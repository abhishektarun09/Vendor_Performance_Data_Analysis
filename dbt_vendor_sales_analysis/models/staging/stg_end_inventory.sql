{{ config(materialized='view') }}

with cte as (
    select
    cast(InventoryId as string) as InventoryId,
    cast(Store as string) as Store,
    cast(City as string) as City,
    cast(Brand as string) as Brand,
    cast(Description as string) as Description,
    cast(Size as string) as Size,
    cast(onHand as int64) as onHand,
    cast(Price as float64) as Price,
    cast(endDate as date) as endDate
from {{ source('raw', 'end_inventory') }}

)

select * from cte