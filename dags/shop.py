from datetime import datetime
from airflow.sdk import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

with DAG(
    dag_id="shop",
    start_date=datetime(2025, 1, 1),
    schedule="@daily",
    catchup=False,
    # folder with the .sql files
    template_searchpath="/opt/airflow/dbt/shop",
) as dag:

    # connection
    revenue = SQLExecuteQueryOperator(
        task_id="customer_revenue",
        # makes airflow look for AIRFLOW_CONN_MYDB
        # connection is in airflow because no dbt
        conn_id="mydb",
        # table
        sql="customer_revenue.sql",
    )