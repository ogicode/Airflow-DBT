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
            # dbt from the venv; build = run models + tests
            "/home/airflow/dbt_venv/bin/dbt build "
            # folder with dbt_project.yml and models
            "--project-dir /opt/airflow/dbt/shops-dbt "
            # folder with profiles.yml (connection)
            "--profiles-dir /opt/airflow/dbt/shops-dbt"
        ),
    )