import datetime
import time
import psycopg2
from airflow.utils.decorators import apply_defaults
from utils import DataFlowBaseOperator


class SalOperator(DataFlowBaseOperator):  # sae -> sal
    defaults = {
        'target_schema': 'sal',
        'source_schema': 'sae',
    }

    @apply_defaults
    def __init__(self, config, pg_conn_str, query=None, *args, **kwargs):
        super(SalOperator, self).__init__(
            config=config,
            pg_conn_str=pg_conn_str,
            *args,
            **kwargs
        )
        self.pg_conn_str = pg_conn_str
        self.config = dict(self.defaults, **config)
        self.query = query

    def execute(self, context):
        with psycopg2.connect(self.pg_conn_str) as conn, conn.cursor() as cursor:
            self.config.update(
                job_id=context['task_instance'].job_id,
                dt=context["task_instance"].execution_date,
            )
            ids = self.get_launch_ids(self.config)
            self.log.info("Ids found: {}".format(ids))

            for launch_id in ids:
                start = time.time()
                self.config.update(
                    launch_id=launch_id,
                )

                cols_sql = """
                select column_name
                     , data_type
                  from information_schema.columns
                 where table_schema = '{target_schema}'
                   and table_name = '{target_table}'
                   and column_name not in ('launch_id', 'effective_dttm');
                """.format(**self.config)

                cursor.execute(cols_sql)
                cols_list = list(cursor.fetchall())
                cols_dtypes = ",\n".join(('{}::{}'.format(col[0], col[1]) for col in cols_list))
                cols = ",\n".join(col[0] for col in cols_list)
                if self.query:
                    transfer_sql = """
                    with x as ({query})
                    insert into {target_schema}.{target_table} (launch_id, {cols})
                    select {job_id}::int as launch_id, {cols_dtypes} from x
                    """.format(query=self.query, cols_dtypes=cols_dtypes, cols=cols, **self.config)
                else:
                    transfer_sql = """
                    insert into {target_schema}.{target_table} (launch_id, {cols})
                    select {job_id}::int as launch_id, {cols_dtypes} from {source_schema}.{source_table}
                    """.format(cols_dtypes=cols_dtypes, cols=cols, **self.config)
                self.log.info('Executing query: {}'.format(transfer_sql))
                cursor.execute(transfer_sql)

                self.config.update(
                    #source_schema=source_schema,
                    duration=datetime.timedelta(seconds=time.time() - start),
                    row_count=cursor.rowcount
                )
                self.log.info('Inserted rows: {row_count}'.format(**self.config))
                self.write_etl_log(self.config)


class DdsHOperator(DataFlowBaseOperator):  # sal -> dds for hubs
    defaults = {
        'target_schema': 'dds',
        'source_schema': 'sal',
    }

    @apply_defaults
    def __init__(self, config, pg_conn_str, *args, **kwargs):
        self.config = dict(
            self.defaults,
            target_table='h_{hub_name}'.format(**config),
            hub_bk='{hub_name}_bk'.format(**config),
            **config
        )
        super(DdsHOperator, self).__init__(
            config=config,
            pg_conn_str=pg_conn_str,
            *args,
            **kwargs
        )
        self.pg_conn_str = pg_conn_str

    def execute(self, context):
        with psycopg2.connect(self.pg_conn_str) as conn, conn.cursor() as cursor:
            self.config.update(
                job_id=context['task_instance'].job_id,
                dt=context["task_instance"].execution_date,
            )
            ids = self.get_launch_ids(self.config)
            self.log.info("Ids found: {}".format(ids))

            for launch_id in ids:
                start = time.time()

                self.config.update(
                    launch_id=launch_id
                )

                insert_sql = '''
                with x as (
                   select {bk_column}
                        , {job_id}
                     from {source_schema}.{source_table} s
                    where {bk_column} is not null
                      and s.launch_id = {launch_id}
                    group by 1
                )
                insert into {target_schema}.{target_table} ({hub_bk}, launch_id)
                select * from x
                    on conflict ({hub_bk})
                    do nothing;
                '''.format(**self.config)

                self.log.info('Executing query: {}'.format(insert_sql))
                cursor.execute(insert_sql)

                self.config.update(
                    row_count=cursor.rowcount
                )
                self.log.info('Row count: {row_count}'.format(**self.config))
                self.config.update(
                    duration=datetime.timedelta(seconds=time.time() - start)
                )
                self.write_etl_log(self.config)


class DdsLOperator(DataFlowBaseOperator):  # sal -> dds for links
    defaults = {
        'target_schema': 'dds',
        'source_schema': 'sal',
    }

    @apply_defaults
    def __init__(self, config, pg_conn_str, *args, **kwargs):
        super(DdsLOperator, self).__init__(
            config=config,
            pg_conn_str=pg_conn_str,
            *args,
            **kwargs
        )
        self.config = dict(
            self.defaults,
            target_table='l_{l_hub_name}_{r_hub_name}'.format(**config),
            **config
        )
        self.pg_conn_str = pg_conn_str

    def execute(self, context):
        with psycopg2.connect(self.pg_conn_str) as conn, conn.cursor() as cursor:
            self.config.update(
                job_id=context['task_instance'].job_id,
                dt=context["task_instance"].execution_date,
            )
            ids = self.get_launch_ids(self.config)
            self.log.info("Ids found: {}".format(ids))

            for launch_id in ids:
                start = time.time()
                self.config.update(
                    launch_id=launch_id,
                )

                insert_sql = '''
                insert into {target_schema}.{target_table} ({l_hub_name}_id, {r_hub_name}_id, launch_id)
                select distinct
                       {l_hub_name}_id
                     , {r_hub_name}_id
                     , {job_id}
                  from {source_schema}.{l_hub_name} s
                  join {target_schema}.h_{l_hub_name} l on s.{l_bk_column} = l.{l_hub_name}_bk
                  join {target_schema}.h_{r_hub_name} r on s.{r_bk_column} = r.{r_hub_name}_bk
                  where s.launch_id = {launch_id}; 
                '''.format(**self.config)

                self.log.info('Executing query: {}'.format(insert_sql))
                cursor.execute(insert_sql)
                self.config.update(
                    row_count=cursor.rowcount,
                    duration=datetime.timedelta(seconds=time.time() - start)
                )
                self.log.info('Row count: {row_count}'.format(**self.config))
                self.write_etl_log(self.config)


class DdsSOperator(DataFlowBaseOperator):  # sal -> dds for sattelites
    defaults = {
        'target_schema': 'dds',
        'source_schema': 'sal',
    }

    @apply_defaults
    def __init__(self, config, pg_conn_str, *args, **kwargs):
        super(DdsSOperator, self).__init__(
            config=config,
            pg_conn_str=pg_conn_str,
            *args,
            **kwargs
        )
        target_fields = config['fields']
        source_fields = [f"{config['prefix']}{field}" for field in config['fields']]
        self.config = dict(
            self.defaults,
            target_table='s_{hub_name}'.format(**config),
            target_fields=', '.join(target_fields),
            source_fields=', '.join(source_fields),
            **config
        )
        self.pg_conn_str = pg_conn_str

    def execute(self, context):
        with psycopg2.connect(self.pg_conn_str) as conn, conn.cursor() as cursor:
            self.config.update(
                job_id=context['task_instance'].job_id,
                dt=context["task_instance"].execution_date,
            )
            ids = self.get_launch_ids(self.config)
            self.log.info("Ids found: {}".format(ids))

            for launch_id in ids:
                start = time.time()
                self.config.update(
                    launch_id=launch_id,
                )

                insert_sql = '''                
                insert into {target_schema}.{target_table} ({hub_name}_id, {target_fields}, launch_id)
                select distinct
                       {hub_name}_id
                     , {source_fields}  
                     , {launch_id}  
                from {source_schema}.{source_table} s
                join dds.h_{hub_name} h on s.{bk_column} = h.{hub_name}_bk 
                where s.launch_id = {launch_id};
                '''.format(**self.config)

                self.log.info('Executing query: {}'.format(insert_sql))
                cursor.execute(insert_sql)
                self.config.update(
                    row_count=cursor.rowcount,
                    duration=datetime.timedelta(seconds=time.time() - start)
                )
                self.log.info('Row count: {row_count}'.format(**self.config))
                self.write_etl_log(self.config)