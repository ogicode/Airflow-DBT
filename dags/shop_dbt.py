from datetime import datetime
from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator

with DAG(
    dag_id="shops_dbt",
    start_date=datetime(2025, 1, 1),
    schedule="@daily",
    catchup=False,
) as dag:

    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command=(
            "/home/airflow/dbt_venv/bin/dbt build "
            "--project-dir /opt/airflow/dbt/shops-dbt "
            "--profiles-dir /opt/airflow/dbt/shops-dbt"
        ),
    )