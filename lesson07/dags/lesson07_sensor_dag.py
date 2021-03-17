from airflow import DAG
from statistic import StatisticsGathering
from datetime import datetime, timedelta
from airflow.operators.sensors import ExternalTaskSensor


DEFAULT_ARGS = {
    "owner": "airflow",
    "start_date": datetime(2021, 3, 11),
    "retries": 1,
    "email_on_failure": False,
    "email_on_retry": False,
    "depends_on_past": True,
    "retry_delay": timedelta(minutes=5),
}

TABLES = ['customer','lineitem','nation','orders','part','partsupp','region','supplier']

with DAG(
    dag_id="pg-data-sensor",
    default_args=DEFAULT_ARGS,
    schedule_interval="@daily",
) as dag1:
    sensing = {
        table: ExternalTaskSensor(
            task_id='wait_for_{table}'.format(table=table),
            external_dag_id='pg-data-flow',
            external_task_id='{table}'.format(table=table),
            execution_delta=timedelta(hours=1),
            timeout=300,
        )
        for table in TABLES
    }

    statistic = {
        table: StatisticsGathering(
            task_id='{table}_statistic'.format(table=table),
            config=dict(
                table='{table}'.format(table=table),
                schema='public'
            ),
            pg_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
            pg_meta_conn_str="host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'",
        )
        for table in TABLES
    }

    for table in TABLES:
        sensing[table] >> statistic[table]