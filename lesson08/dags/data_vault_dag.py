from airflow import DAG
from postgres import DataTransferPostgres
from layers import SalOperator, DdsSOperator, DdsHOperator, DdsLOperator
from datetime import datetime
import yaml
import os

with open(os.path.join(os.path.dirname(__file__), 'schema.yaml'), encoding='utf-8') as f:
    YAML_DATA = yaml.safe_load(f)

DEFAULT_ARGS = {
    "owner": "airflow",
    "start_date": datetime(2021, 1, 25),
    "retries": 1,
    "email_on_failure": False,
    "email_on_retry": False,
    "depends_on_past": False,
}

SAE_QUERY = 'select * from {table}'
SAL_QUERY = {
    'partsupp': 'select md5(concat(ps_partkey,ps_suppkey)) ps_partsuppkey, *  from sae.partsupp',
    'lineitem': 'select md5(concat(l_orderkey,l_partkey,l_suppkey)) l_lineitemkey, *  from sae.lineitem',
    'default': 'select * from sae.{table}'
}
SOURCE_PG_CONN_STR = "host='etl_postgres_01' port=5432 dbname='benchmark_db' user='root' password='postgres'"
PG_CON_STR = "host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'"
PG_META_CONN_STR = "host='etl_postgres_02' port=5432 dbname='benchmark_db' user='root' password='postgres'"

with DAG(
    dag_id="pg-data-vault",
    default_args=DEFAULT_ARGS,
    schedule_interval="@daily",
    max_active_runs=1,
    tags=['data-flow'],
) as dag1:
    sae = {
        table: DataTransferPostgres(
            config=dict(table=f'sae.{table}'),
            query=SAE_QUERY.format(table=table),
            task_id=f'sae_{table}',
            source_pg_conn_str=SOURCE_PG_CONN_STR,
            pg_conn_str=PG_CON_STR,
            pg_meta_conn_str=PG_META_CONN_STR,
        )
        for table in YAML_DATA['sources']['tables'].keys()
    }

    sal = {
        table: SalOperator(
            config=dict(
                target_table=table,
                source_table=table,
            ),
            query=SAL_QUERY[table] if table in SAL_QUERY else SAL_QUERY['default'].format(table=table),
            task_id=f'sal_{table}',
            pg_conn_str=PG_CON_STR,
            pg_meta_conn_str=PG_META_CONN_STR,
        )
        for table in YAML_DATA['sources']['tables'].keys()
    }

    for target_table, task in sal.items():
        sae[target_table] >> task

    hubs = {
        hub_name: {
            table: DdsHOperator(
                task_id=f'dds.h_{hub_name}',
                config={
                    'hub_name': hub_name,
                    'source_table': table,
                    'bk_column': bk_column
                },
                pg_conn_str=PG_CON_STR,
                pg_meta_conn_str=PG_META_CONN_STR,
            )
            for table, cols in YAML_DATA['sources']['tables'].items()
            for col in cols['columns']
            for bk_column, inf in col.items()
            if inf.get('bk_for') == hub_name
        }
        for hub_name in YAML_DATA['dds']['hubs'].keys()
    }

    for hub, info in hubs.items():
        for source_table, task in info.items():
            sal[source_table] >> task

    satellites = {
        satellite_name: {
            table_name: DdsSOperator(
                task_id=f'dds.s_{satellite_name}',
                pg_conn_str=PG_CON_STR,
                pg_meta_conn_str=PG_META_CONN_STR,
                config=dict(
                    hub_name=satellite_name,
                    bk_column=bk_column,
                    source_table=table_name,
                    prefix=cols['prefix'],
                    fields=info['columns'].keys(),
                )
            )
            for table_name, cols in YAML_DATA['sources']['tables'].items()
            for col in cols['columns']
            for bk_column, inf in col.items()
            if inf.get('bk_for') == satellite_name
        }
        for satellite_name, info in YAML_DATA['dds']['satellites'].items()

    }

    for table_name, info in satellites.items():
        hubs[table_name][table_name] >> info[table_name]

    links = {
        (link['l_hub_name'], link['r_hub_name']): DdsLOperator(
            task_id='dds.l_{l_hub_name}_{r_hub_name}'.format(l_hub_name=link['l_hub_name'], r_hub_name=link['r_hub_name']),
            pg_conn_str=PG_CON_STR,
            pg_meta_conn_str=PG_META_CONN_STR,
            config=dict(
                l_hub_name=link['l_hub_name'],
                r_hub_name=link['r_hub_name'],
                l_bk_column=link['l_bk_column'],
                r_bk_column=link['r_bk_column'],
                source_table=link['l_hub_name'],
            )
        )
        for link in YAML_DATA['dds']['links']
    }

    for (l_hub, r_hub), task in links.items():
        hubs[l_hub][l_hub] >> task
        hubs[r_hub][r_hub] >> task
