from datetime import datetime
import pandas as pd
import ssl
from sqlalchemy import create_engine

from airflow import DAG
from airflow.models import Variable
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from airflow.models import Variable

URL = Variable.get("blood_pressure_url")
PG_CONN_STRING = Variable.get("db_conn_string")

ssl._create_default_https_context = ssl._create_unverified_context

def blood_pressure_from_url_to_pg():
    engine = create_engine(PG_CONN_STRING, echo=False)
    df=pd.read_csv(URL)
    df.to_sql('blood_pressure', con=engine, if_exists='replace')


with DAG(
    dag_id="blood_pressure_dag.py",
    start_date=datetime(2022, 1, 1),
    schedule_interval="@once",
    catchup=False,
) as dag:
    start_dag = DummyOperator(task_id="start_dag")
    end_dag = DummyOperator(task_id="end_dag")
    blood_pressure_from_url_to_pg = PythonOperator(
        task_id="blood_pressure_from_url_to_pg",
        python_callable=blood_pressure_from_url_to_pg)

    start_dag >> blood_pressure_from_url_to_pg >> end_dag