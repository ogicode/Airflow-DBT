from datetime import datetime
import os
import subprocess
import psycopg
from airflow.sdk import DAG
from airflow.providers.standard.operators.python import PythonOperator

# load csv to bronze
def load_csv():
    # connect
    with psycopg.connect(
        host=os.environ["NEON_HOST"],
        dbname="webshops",
        user="neondb_owner",
        password=os.environ["NEON_PASSWORD"],
        sslmode="require",
    ) as conn:
        with conn.cursor() as cur:
            # empty bronze
            cur.execute("truncate bronze.customers")
            # add csv to bronze
            with open("/opt/airflow/data/customers.csv") as f, cur.copy("copy bronze.customers from stdin with (format csv, header true)") as copy:
                copy.write(f.read())

# run dbt
def run_dbt():
    subprocess.run(
        [
            "/home/airflow/dbt_venv/bin/dbt", "build",
            # dbt_project.yml
            "--project-dir", "/opt/airflow/dbt/webshops",
            # profiles.yml
            "--profiles-dir", "/opt/airflow/dbt",
        ],
        check=True,
    )

# dag specs
with DAG(
    dag_id="dbt_webshops",
    start_date=datetime(2025, 1, 1),
    schedule="@daily",
    catchup=False,
) as dag:

    load = PythonOperator(task_id="load_csv", python_callable=load_csv)
    dbt_build = PythonOperator(task_id="dbt_build", python_callable=run_dbt)

    load >> dbt_build