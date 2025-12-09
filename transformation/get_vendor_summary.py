import pandas as pd
import time
import sys

from src.logger import logging
from src.exception import CustomException
from ingestion.ingestion_to_db import ingest_db
from src.postgres_session import get_postgres_connection

engine = get_postgres_connection()

def create_vendor_summary(conn):
    try:
        vendor_sales_summary = pd.read_sql("""
        WITH FreightSummary AS (
            SELECT
                "VendorNumber",
                SUM("Freight") AS "FreightCost"
            FROM vendor_invoice
            GROUP BY "VendorNumber"
        ),

        PurchaseSummary AS (
            SELECT
                p."VendorNumber",
                p."VendorName",
                p."Brand",
                p."Description",
                p."PurchasePrice",
                pp."Volume",
                pp."Price" AS "ActualPrice",
                SUM(p."Quantity") AS "TotalPurchaseQuantity",
                SUM(p."Dollars") AS "TotalPurchaseDollars"
            FROM purchases p
            JOIN purchase_prices pp
                ON p."Brand" = pp."Brand"
            WHERE p."PurchasePrice" > 0
            GROUP BY
                p."VendorNumber",
                p."VendorName",
                p."Brand",
                p."Description",
                p."PurchasePrice",
                pp."Price",
                pp."Volume"
        ),

        SalesSummary AS (
            SELECT
                "VendorNo",
                "Brand",
                SUM("SalesDollars") AS "TotalSalesDollars",
                SUM("SalesPrice") AS "TotalSalesPrice",
                SUM("SalesQuantity") AS "TotalSalesQuantity",
                SUM("ExciseTax") AS "TotalExciseTax"
            FROM sales
            GROUP BY "VendorNo", "Brand"
        )

        SELECT
            ps."VendorNumber",
            ps."VendorName",
            ps."Brand",
            ps."Description",
            ps."PurchasePrice",
            ps."ActualPrice",
            ps."Volume",
            ps."TotalPurchaseQuantity",
            ps."TotalPurchaseDollars",
            ss."TotalSalesQuantity",
            ss."TotalSalesDollars",
            ss."TotalSalesPrice",
            ss."TotalExciseTax",
            fs."FreightCost"
        FROM PurchaseSummary ps
        LEFT JOIN SalesSummary ss
            ON ps."VendorNumber" = ss."VendorNo"
            AND ps."Brand" = ss."Brand"
        LEFT JOIN FreightSummary fs
            ON ps."VendorNumber" = fs."VendorNumber"
        ORDER BY ps."TotalPurchaseDollars" DESC;

        """, conn)
        
        return vendor_sales_summary
    
    except Exception as e:
        raise CustomException(e, sys)

def clean_data(df):
    try:
        df['Volume'] = df['Volume'].astype('float64')
        df.fillna(0, inplace = True)
        df['VendorName'] = df['VendorName'].str.strip()
        df['Description'] = df['Description'].str.strip()    
        df['GrossProfit'] = df['TotalSalesDollars'] - df['TotalPurchaseDollars']
        df['ProfitMargin'] = (df['GrossProfit'] / df['TotalSalesDollars']) * 100
        df['StockTurnover'] = df['TotalSalesQuantity'] / df['TotalPurchaseQuantity']
        df['SalesToPurchaseRatio'] = df['TotalSalesDollars'] / df['TotalPurchaseDollars']
    
        return df
    
    except Exception as e:
        raise CustomException(e, sys)

if __name__ == '__main__':
    
    start_time = time.time()
    
    logging.info('---------------Creating Vendor Summary Table---------------')
    summary_df = create_vendor_summary(engine)
    logging.info(summary_df.head())
    
    logging.info('---------------Cleaning Data---------------')
    clean_df = clean_data(summary_df)
    logging.info(clean_df.head())
    
    logging.info('---------------Ingesting Data in Database---------------')
    ingest_db(df=clean_df, table_name="vendor_sales_summary", engine=engine)
    logging.info("Ingestion Completed")
    end_time = time.time()
    time_taken = (end_time - start_time)/60
    logging.info(f"Time taken {time_taken} minutes.")