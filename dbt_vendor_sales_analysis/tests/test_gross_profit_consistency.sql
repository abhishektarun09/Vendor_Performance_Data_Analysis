SELECT
    VendorNumber,
    Brand,
    TotalSalesDollars,
    TotalPurchaseDollars,
    GrossProfit
FROM {{ ref('vendor_sales_mart') }}
WHERE TotalSalesDollars IS NOT NULL
  AND GrossProfit != (TotalSalesDollars - TotalPurchaseDollars)
