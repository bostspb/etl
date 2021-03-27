import psycopg2
import logging
from airflow.models import BaseOperator

class DataFlowBaseOperator(BaseOperator):
    def __init__(self, pg_meta_conn_str, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.pg_meta_conn_str = pg_meta_conn_str

    def write_etl_log(self, config):
        with psycopg2.connect(self.pg_meta_conn_str) as conn, conn.cursor() as cursor:
            query = '''
            insert into etl.log (
                   source_launch_id
                 , target_schema
                 , target_table
                 , target_launch_id
                 , row_count
                 , duration
                 , load_date
            )
            select {launch_id}
                , '{target_schema}'
                , '{target_table}'
                , {job_id}
                , {row_count}
                , '{duration}'
                , '{dt}'
            '''
            cursor.execute(query.format(**config))
            logging.info('Log update: {target_table} : {job_id}'.format(**config))
            conn.commit()


    def write_etl_statistic(self, config):
        with psycopg2.connect(self.pg_meta_conn_str) as conn, conn.cursor() as cursor:
            query = '''
            insert into etl.statistic (
                   table_name
                 , column_name
                 , cnt_nulls
                 , cnt_all
                 , load_date
            )
            with x as (
                select '{table}' as table_name
                     , '{column}' as column_name
                     , {cnt_nulls} as cnt_nulls
                     , {cnt_all} as cnt_all
                     , {launch_id} as launch_id
            )
            select table_name
                 , column_name
                 , cnt_nulls
                 , cnt_all
                 , load_date
              from x left join etl.log l
                on x.launch_id = l.target_launch_id
            '''
            cursor.execute(query.format(**config))
            conn.commit()

    def get_load_dates(self, config):
        with psycopg2.connect(self.pg_meta_conn_str) as conn, conn.cursor() as cursor:
            query = '''
            select array_agg(distinct load_date order by load_date)
                from etl.log
                where target_table = '{target_table}'
                and target_schema = '{target_schema}'
                and source_launch_id = -1
            '''
            cursor.execute(query.format(**config))
            dates = cursor.fetchone()[0]
        if dates:
            return dates
        else:
            return []

    def get_launch_ids(self, config):
        with psycopg2.connect(self.pg_meta_conn_str) as conn, conn.cursor() as cursor:
            query = '''
            select array_agg(distinct target_launch_id order by target_launch_id)::int[]
                from etl.log
                where target_launch_id not in (
                select source_launch_id
                    from etl.log
                    where target_table = '{target_table}'
                    and target_schema = '{target_schema}'
                    and source_launch_id is not null
                    )
                and target_table = '{source_table}'
                and target_schema = '{source_schema}'
            '''
            cursor = conn.cursor()
            logging.info('Executing metadata query: {}'.format(query.format(**config)))
            cursor.execute(query.format(**config))
            ids = cursor.fetchone()[0]
            logging.info('Launch_ids: {}'.format(ids))
        return tuple(ids) if ids else ()