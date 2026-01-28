import pandas as pd
import os
import time
import sys

from src.logger import logging
from src.exception import CustomException
from src.postgres_session import get_postgres_connection

engine = get_postgres_connection()

def ingest_db_local(df, table_name, engine):
    """This function ingests data into SQL Database"""
    
    try:
        df.to_sql(table_name, con = engine, if_exists = 'replace', index = False)
        
    except Exception as e:
        raise CustomException(e, sys)

def load_raw_data():    
    """This function will load CSV files as pandas dataframe and ingest into db"""
    
    try:
        start_time = time.time()
        for file in os.listdir('data'):
            if '.csv' in file:
                df = pd.read_csv('data/'+file)
                logging.info(f"Ingesting {file} in db.")
                ingest_db_local(df, file[:-4], engine)
        end_time = time.time()
        logging.info("----------Ingestion Completed----------")
        total_time = (end_time - start_time)/60
        logging.info(f"Time taken {total_time} minutes.")
        
    except Exception as e:
        raise CustomException(e, sys)
    
if __name__ == '__main__':
    load_raw_data()