import psycopg2

with open("dds.sql", "r") as dds_file:
    dds_query = dds_file.read()

with open("etl.sql", "r") as etl_file:
    etl_query = etl_file.read()

with open("sae.sql", "r") as sae_file:
    sae_query = sae_file.read()

with open("sal.sql", "r") as sal_file:
    sal_query = sal_file.read()


conn_string= "host='localhost' port=5433 dbname='benchmark_db' user='root' password='postgres'"
with psycopg2.connect(conn_string) as conn, conn.cursor() as cursor:
    cursor.execute(dds_query)
    cursor.execute(etl_query)
    cursor.execute(sae_query)
    cursor.execute(sal_query)