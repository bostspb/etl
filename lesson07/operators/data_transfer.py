import logging
import time
import psycopg2
import datetime
from airflow.utils.decorators import apply_defaults
from utils import DataFlowBaseOperator


class DataTransfer(DataFlowBaseOperator):
    @apply_defaults
    def __init__(self, config, pg_conn_str, pg_meta_conn_str, date_check=False, *args, **kwargs):
        super(DataTransfer, self).__init__(pg_meta_conn_str=pg_meta_conn_str, *args, **kwargs)
        self.config = config
        self.pg_conn_str = pg_conn_str
        self.pg_meta_conn_str = pg_meta_conn_str
        self.date_check = date_check

    def provide_data(self, csv_file, context):
        pass

    def execute(self, context):
        copy_statement = """
        COPY {target_schema}.{target_table} ({columns}) FROM STDIN with
        DELIMITER '\t'
        CSV
        ESCAPE '\\'
        NULL '';
        """

        schema_name = "{table}".format(**self.config).split(".")
        self.config.update(
            target_schema=schema_name[0],
            target_table=schema_name[1],
            job_id=context["task_instance"].job_id,
            dt=context["task_instance"].execution_date,
        )

        if self.date_check and context["execution_date"] in self.get_load_dates(
            self.config
        ):
            logging.info("Data already load")
            return
        with psycopg2.connect(self.pg_conn_str) as conn, conn.cursor() as cursor:
            start = time.time()
            cursor.execute("""
            select column_name
              from information_schema.columns
             where table_schema = '{target_schema}'
               and table_name = '{target_table}';
            """.format(**self.config)
            )
            result = cursor.fetchall()
            columns = ", ".join('"{}"'.format(row) for row, in result)
            self.config.update(columns=columns)

            with open("transfer.csv", "w", encoding="utf-8") as csv_file:
                self.provide_data(csv_file, context)

            self.log.info("writing succed")

            with open('transfer.csv', 'r', encoding="utf-8") as f:
                cursor.copy_expert(copy_statement.format(**self.config), f)

            self.config.update(
                launch_id=-1,
                duration=datetime.timedelta(seconds=time.time() - start),
                row_count=cursor.rowcount
            )
            self.write_etl_log(self.config)