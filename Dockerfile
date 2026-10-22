# Debian plus Airflow
FROM apache/airflow:3.3.2
# dbt in venv because dependency conflicts, since dbt and Airflow share libraries that can clash on versions
RUN python -m venv /home/airflow/dbt_venv && \
    /home/airflow/dbt_venv/bin/pip install dbt-core==1.12.5 dbt-postgres==1.11.0
# psycopg
RUN pip install "psycopg[binary]==3.3.6"