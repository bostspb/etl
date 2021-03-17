from datetime import datetime
from airflow import DAG
from postgres import DataTransferPostgres


DEFAULT_ARGS = {
    "owner": "airflow",
    "start_date": datetime(2021, 3, 10),
    "retries": 1,
    "email_on_failure": False,
    "email_on_retry": False,
    "depends_on_past": True,
}

TABLES = ['customer','lineitem','nation','orders','part','partsupp','region','supplier']

with DAG(
    dag_id="pg-data-flow",
    default_args=DEFAULT_ARGS,
    schedule_interval="@daily",
    max_active_runs=1,
    tags=['data-flow'],
) as dag1:
    tasks = {
        table: DataTransferPostgres(
            config=dict(table='public.{table}'.format(table=table)),
            query='select * from {table}'.format(table=table),
            task_id='{table}'.format(table=table),
            source_pg_conn_str="host='etl_postgres_01' port=5432 dbname='benchmark_db' user='root' password='postgres'",
            pg_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
            pg_meta_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
        )
        for table in TABLES
    }
