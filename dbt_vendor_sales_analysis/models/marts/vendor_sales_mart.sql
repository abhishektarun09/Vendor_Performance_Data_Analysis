WITH FreightSummary AS (
            SELECT
                VendorNumber,
                SUM(Freight) AS FreightCost
            FROM  {{ ref('stg_vendor_invoice') }}
            GROUP BY VendorNumber
        ),

        PurchaseSummary AS (
            SELECT
                p.VendorNumber,
                p.VendorName,
                p.Brand,
                p.Description,
                p.PurchasePrice,
                pp.Volume,
                pp.Price AS ActualPrice,
                SUM(p.Quantity) AS TotalPurchaseQuantity,
                SUM(p.Dollars) AS TotalPurchaseDollars
            FROM  {{ ref('stg_purchases') }} p
            JOIN {{ ref('stg_purchase_prices') }} pp
                ON p.Brand = pp.Brand
            WHERE p.PurchasePrice > 0
            GROUP BY
                p.VendorNumber,
                p.VendorName,
                p.Brand,
                p.Description,
                p.PurchasePrice,
                pp.Price,
                pp.Volume
        ),

        SalesSummary AS (
            SELECT
                VendorNo,
                Brand,
                SUM(SalesDollars) AS TotalSalesDollars,
                SUM(SalesPrice) AS TotalSalesPrice,
                SUM(SalesQuantity) AS TotalSalesQuantity,
                SUM(ExciseTax) AS TotalExciseTax
            FROM {{ ref('stg_sales') }}
            GROUP BY VendorNo, Brand
        )

        SELECT
            ps.VendorNumber,
            trim(ps.VendorName) as VendorName,
            ps.Brand,
            trim(ps.Description) as Description,
            ps.PurchasePrice,
            ps.ActualPrice,
            cast(ps.Volume as float64) as Volume,
            ps.TotalPurchaseQuantity,
            ps.TotalPurchaseDollars,
            ss.TotalSalesQuantity,
            ss.TotalSalesDollars,
            ss.TotalSalesPrice,
            ss.TotalExciseTax,
            fs.FreightCost,
            ss.TotalSalesDollars - ps.TotalPurchaseDollars as GrossProfit,
            (ss.TotalSalesDollars - ps.TotalPurchaseDollars) / ss.TotalSalesDollars * 100 as ProfitMargin,
            (ss.TotalSalesQuantity / ps.TotalPurchaseQuantity) as StockTurnover,
            (ss.TotalSalesDollars / ps.TotalPurchaseDollars) as SalesToPurchaseRatio
        FROM PurchaseSummary ps
        LEFT JOIN SalesSummary ss
            ON ps.VendorNumber = ss.VendorNo
            AND ps.Brand = ss.Brand
        LEFT JOIN FreightSummary fs
            ON ps.VendorNumber = fs.VendorNumber
        ORDER BY ps.TotalPurchaseDollars DESC