FROM apache/airflow:3.3.0
RUN python -m venv /home/airflow/dbt_venv && \
    /home/airflow/dbt_venv/bin/pip install dbt-postgres
RUN pip install "psycopg[binary]"