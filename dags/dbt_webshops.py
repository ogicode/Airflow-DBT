# Runs the dbt project daily: builds silver and gold models and runs tests.
from datetime import datetime

from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator

with DAG(
    dag_id="dbt_webshops",
    start_date=datetime(2025, 1, 1),
    schedule="@daily",
    catchup=False,
) as dag:

    dbt_build = BashOperator(
        task_id="dbt_build",
        # run dbt
        bash_command="/home/airflow/dbt_venv/bin/dbt build --project-dir /opt/airflow/dbt --profiles-dir /opt/airflow/dbt",
    ) 