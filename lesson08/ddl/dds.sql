CREATE SCHEMA IF NOT EXISTS dds;
drop table if exists dds.h_part, dds.h_supplier, dds.h_partsupp, dds.h_lineitem, dds.h_orders, dds.h_customer, dds.h_nation, dds.h_region, dds.l_customer_nation, dds.l_nation_region, dds.l_orders_customer, dds.l_lineitem_orders, dds.l_lineitem_part, dds.l_lineitem_supplier, dds.l_partsupp_part, dds.l_partsupp_supplier, dds.s_part, dds.s_supplier, dds.s_partsupp, dds.s_lineitem, dds.s_orders, dds.s_customer, dds.s_nation, dds.s_region;


create table dds.h_part (
    part_id SERIAL PRIMARY KEY,
    part_bk int,
    launch_id int,
    UNIQUE(part_bk)
);


create table dds.h_supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_bk int,
    launch_id int,
    UNIQUE(supplier_bk)
);


create table dds.h_partsupp (
    partsupp_id SERIAL PRIMARY KEY,
    partsupp_bk varchar,
    launch_id int,
    UNIQUE(partsupp_bk)
);


create table dds.h_lineitem (
    lineitem_id SERIAL PRIMARY KEY,
    lineitem_bk varchar,
    launch_id int,
    UNIQUE(lineitem_bk)
);


create table dds.h_orders (
    orders_id SERIAL PRIMARY KEY,
    orders_bk int,
    launch_id int,
    UNIQUE(orders_bk)
);


create table dds.h_customer (
    customer_id SERIAL PRIMARY KEY,
    customer_bk int,
    launch_id int,
    UNIQUE(customer_bk)
);


create table dds.h_nation (
    nation_id SERIAL PRIMARY KEY,
    nation_bk int,
    launch_id int,
    UNIQUE(nation_bk)
);


create table dds.h_region (
    region_id SERIAL PRIMARY KEY,
    region_bk int,
    launch_id int,
    UNIQUE(region_bk)
);


create table dds.l_customer_nation (
    customer_id int,
    nation_id int,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.l_nation_region (
    nation_id int,
    region_id int,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.l_orders_customer (
    orders_id int,
    customer_id int,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.l_lineitem_orders (
    lineitem_id int,
    orders_id int,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.l_lineitem_part (
    lineitem_id int,
    part_id int,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.l_lineitem_supplier (
    lineitem_id int,
    supplier_id int,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.l_partsupp_part (
    partsupp_id int,
    part_id int,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.l_partsupp_supplier (
    partsupp_id int,
    supplier_id int,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.s_part (
    part_id int,
    name text, mfgr text, brand text, type text, size int, container text, retailprice numeric, comment text,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.s_supplier (
    supplier_id int,
    name text, address text, phone text, acctbal int, comment text,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.s_partsupp (
    partsupp_id int,
    availqty int, supplycost numeric, comment text,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.s_lineitem (
    lineitem_id int,
    linenumber int, quantity numeric, extendedprice numeric, discount numeric, tax numeric, returnflag text, linestatus text, shipdate date, commitdate date, receiptdate date, shipinstruct text, shipmode text, comment text,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.s_orders (
    orders_id int,
    orderstatus text, totalprice numeric, orderdate date, orderpriority text, shippriority int, clerk text, comment text,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.s_customer (
    customer_id int,
    name text, address text, phone text, acctbal numeric, mktsegment text, comment text,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.s_nation (
    nation_id int,
    name text, comment text,
    launch_id int,
    effective_dttm timestamp default now()
);


create table dds.s_region (
    region_id int,
    name text, comment text,
    launch_id int,
    effective_dttm timestamp default now()
);

