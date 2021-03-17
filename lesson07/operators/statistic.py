import psycopg2
from airflow.utils.decorators import apply_defaults
from utils import DataFlowBaseOperator


class StatisticsGathering(DataFlowBaseOperator):
    @apply_defaults
    def __init__(self, config, pg_conn_str, pg_meta_conn_str, *args, **kwargs):
        super(StatisticsGathering, self).__init__(pg_meta_conn_str=pg_meta_conn_str, *args, **kwargs)
        self.config = config
        self.pg_conn_str = pg_conn_str
        self.pg_meta_conn_str = pg_meta_conn_str

    def execute(self, context):
        with psycopg2.connect(self.pg_conn_str) as conn, conn.cursor() as cursor:
            # Получаем перечень полей в таблице
            cursor.execute("""
            select column_name
              from information_schema.columns
             where table_schema = '{schema}'
               and table_name = '{table}'
               and column_name not in ('launch_id', 'effective_dttm');
            """.format(**self.config)
            )
            columns = cursor.fetchall()

            # Получаем ID последней заливки данных
            cursor.execute("select max(launch_id) from {table}".format(**self.config))
            last_launch_id = cursor.fetchone()
            self.config.update(launch_id=last_launch_id[0])

            # Подсчитываем количество ненулловых значений в каждом столбце и общее количество записей
            cnt_select = ", ".join('count({}) as {}_count'.format(col, col) for col, in columns)
            cursor.execute("""
            select {cnt_select}, count(*) as all_count	
            from {table}
            where launch_id = {launch_id}
            """.format(**self.config, cnt_select=cnt_select)
            )
            counts = cursor.fetchall()

            # Записываем статистику по каждому полю таблицы
            i = 0
            while i < len(columns):
                self.config.update(
                    column=columns[i][0],
                    cnt_nulls=counts[0][-1] - counts[0][i],
                    cnt_all=counts[0][-1]
                )
                self.write_etl_statistic(self.config)
                i += 1
