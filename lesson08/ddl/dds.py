import yaml

with open('../dags/schema.yaml', encoding='utf-8') as f:
    YAML_DATA = yaml.safe_load(f)

HUB_SQL = '''
create table dds.h_{table} (
    {table}_id SERIAL PRIMARY KEY,
    {table}_bk {dtype},
    launch_id int,
    UNIQUE({table}_bk)
);
'''

LINK_SQL = '''
create table dds.l_{table_1}_{table_2} (
    {table_1}_id int,
    {table_2}_id int,
    launch_id int,
    effective_dttm timestamp default now()
);
'''

SATELLITE_SQL = '''
create table dds.s_{table} (
    {table}_id int,
    {fields_with_type},
    launch_id int,
    effective_dttm timestamp default now()
);
'''

dds = ''
tables = []

for table, info in YAML_DATA['dds']['hubs'].items():
    dds += HUB_SQL.format(table=table,dtype=info['bk_dtype']) + "\n"
    tables.append(f'dds.h_{table}')


for links in YAML_DATA['dds']['links']:
    dds += LINK_SQL.format(table_1=links[0], table_2=links[1]) + "\n"
    tables.append(f'dds.l_{links[0]}_{links[1]}')


for table, info in YAML_DATA['dds']['satellites'].items():
    fields = []
    for field, dtype in info['columns'].items():
        fields.append(field + ' ' + dtype)
    dds += SATELLITE_SQL.format(table=table, fields_with_type=", ".join(fields)) + "\n"
    tables.append(f'dds.s_{table}')


dds_header = 'CREATE SCHEMA IF NOT EXISTS dds;\n'
dds_header += 'drop table if exists ' + ', '.join(tables) + ';\n\n'
dds = dds_header + dds

dds_file = open("dds.sql", "w")
dds_file.write(dds)
dds_file.close()
