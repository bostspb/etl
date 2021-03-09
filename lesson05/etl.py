import psycopg2


def dump_db_to_csv(conn_string, tables):
    with psycopg2.connect(conn_string) as conn, conn.cursor() as cursor:
        for table in tables:
            query = f"COPY {table} TO STDOUT WITH DELIMITER ',' CSV HEADER;"
            with open(f'./result_tables/{table}.csv', 'w') as csv_file:
                cursor.copy_expert(query, csv_file)


def load_in_db_from_csv(conn_string, tables):
    with psycopg2.connect(conn_string) as conn, conn.cursor() as cursor:
        for table in tables:
            query = f"COPY {table} from STDIN WITH DELIMITER ',' CSV HEADER;"
            with open(f'./result_tables/{table}.csv', 'r') as csv_file:
                cursor.copy_expert(query, csv_file)


db_01_connection = "host='localhost' port=54320 dbname='benchmark_db' user='root' password='postgres'"
db_02_connection = "host='localhost' port=5433 dbname='benchmark_db' user='root' password='postgres'"
tables = ['customer','lineitem','nation','orders','part','partsupp','region','supplier']

dump_db_to_csv(db_01_connection, tables)
load_in_db_from_csv(db_02_connection, tables)