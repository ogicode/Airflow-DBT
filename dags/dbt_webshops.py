from datetime import datetime
import os
import psycopg
from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator
from airflow.providers.standard.operators.python import PythonOperator

def load_csv():
    with psycopg.connect(
        host=os.environ["NEON_HOST"],
        dbname="webshops",
        user="neondb_owner",
        # from docker container in auth
        password=os.environ["NEON_PASSWORD"],
        sslmode="require",
    ) as conn:
        with conn.cursor() as cur:
            cur.execute("truncate bronze.customers")
            with open("/opt/airflow/data/customers.csv") as f, cur.copy("copy bronze.customers from stdin with (format csv, header true)") as copy:
                copy.write(f.read())

with DAG(
    dag_id="dbt_webshops",
    start_date=datetime(2025, 1, 1),
    schedule="@daily",
    catchup=False,
) as dag:

    load = PythonOperator(task_id="load_csv", python_callable=load_csv)

    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command="/home/airflow/dbt_venv/bin/dbt build --project-dir /opt/airflow/dbt --profiles-dir /opt/airflow/dbt",
    )

    load >> dbt_build