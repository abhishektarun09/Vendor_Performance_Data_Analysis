import pandas as pd
import os
import time
import logging
from sqlalchemy import create_engine

logging.basicConfig(
    filename='logs/ingestion_db.log',
    level=logging.DEBUG,
    format='%(asctime)s -%(levelname)s -%(message)s',
    filemode='a'
)

engine = create_engine('sqlite:///inventory.db')

def ingest_db(df, table_name, engine):
    """This function ingests data into SQL Database"""
    
    df.to_sql(table_name, con = engine, if_exists = 'replace', index = False)

def load_raw_data():    
    """This function will load CSV files as pandas dataframe and ingest into db"""
    
    start_time = time.time()
    for file in os.listdir('data'):
        if '.csv' in file:
            df = pd.read_csv('data/'+file)
            logging.info(f"Ingesting {file} in db.")
            ingest_db(df, file[:-4], engine)
    end_time = time.time()
    logging.info("----------Ingestion Completed----------")
    total_time = (end_time - start_time)/60
    logging.info(f"Time taken {total_time} minutes.")
    
if __name__ == '__main__':
    load_raw_data()