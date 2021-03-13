from datetime import datetime
from airflow import DAG
from postgres import DataTransferPostgres


DEFAULT_ARGS = {
    "owner": "airflow",
    "start_date": datetime(2021, 1, 25),
    "retries": 1,
    "email_on_failure": False,
    "email_on_retry": False,
    "depends_on_past": True,
}

with DAG(
    dag_id="pg-data-flow",
    default_args=DEFAULT_ARGS,
    schedule_interval="@daily",
    max_active_runs=1,
    tags=['data-flow'],
) as dag1:
    t1 = DataTransferPostgres(
        config={'table': 'public.customer'},
        query='select * from customer',
        task_id='customer',
        source_pg_conn_str="host='etl_postgres_01' port=5432 dbname='benchmark_db' user='root' password='postgres'",
        pg_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
    )
    """
    t2 = DataTransferPostgres(
        config={'table': 'public.lineitem'},
        query='select * from lineitem',
        task_id='lineitem',
        source_pg_conn_str="host='etl_postgres_01' port=5432 dbname='benchmark_db' user='root' password='postgres'",
        pg_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
    )"""
    t3 = DataTransferPostgres(
        config={'table': 'public.nation'},
        query='select * from nation',
        task_id='nation',
        source_pg_conn_str="host='etl_postgres_01' port=5432 dbname='benchmark_db' user='root' password='postgres'",
        pg_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
    )
    t4 = DataTransferPostgres(
        config={'table': 'public.orders'},
        query='select * from orders',
        task_id='orders',
        source_pg_conn_str="host='etl_postgres_01' port=5432 dbname='benchmark_db' user='root' password='postgres'",
        pg_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
    )
    t5 = DataTransferPostgres(
        config={'table': 'public.part'},
        query='select * from part',
        task_id='part',
        source_pg_conn_str="host='etl_postgres_01' port=5432 dbname='benchmark_db' user='root' password='postgres'",
        pg_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
    )
    t6 = DataTransferPostgres(
        config={'table': 'public.partsupp'},
        query='select * from partsupp',
        task_id='partsupp',
        source_pg_conn_str="host='etl_postgres_01' port=5432 dbname='benchmark_db' user='root' password='postgres'",
        pg_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
    )
    t7 = DataTransferPostgres(
        config={'table': 'public.region'},
        query='select * from region',
        task_id='region',
        source_pg_conn_str="host='etl_postgres_01' port=5432 dbname='benchmark_db' user='root' password='postgres'",
        pg_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
    )
    t8 = DataTransferPostgres(
        config={'table': 'public.supplier'},
        query='select * from supplier',
        task_id='supplier',
        source_pg_conn_str="host='etl_postgres_01' port=5432 dbname='benchmark_db' user='root' password='postgres'",
        pg_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
    )
