# This DAG fetches a random Star Wars character from the SWAPI API and logs it into Neon Postgres.
from datetime import datetime
import random
import httpx
import psycopg2

from airflow.sdk import DAG, task

CONN = "postgresql://user:password@ep-xxxx.eu-central-1.aws.neon.tech/webshops?sslmode=require"


with DAG(
    dag_id="starwars_postgres_log",
    start_date=datetime(2025, 1, 1),
    schedule=None,
    catchup=False,
) as dag:

    @task
    def fetch_starwars_character():
        with httpx.Client(timeout=30.0) as client:
            people = client.get("https://swapi.info/api/people").json()

        return random.choice(people)["name"]

    @task
    def create_table_and_insert(character_name):
        with psycopg2.connect(CONN) as conn, conn.cursor() as cur:
            cur.execute("""
                create table if not exists public.starwars_log (
                    created_at timestamp,
                    character_name text
                );
            """)
            cur.execute(
                "insert into public.starwars_log (created_at, character_name) values (%s, %s);",
                (datetime.now(), character_name),
            )

        print(f"Inserted: {character_name}")

    character = fetch_starwars_character()
    create_table_and_insert(character)