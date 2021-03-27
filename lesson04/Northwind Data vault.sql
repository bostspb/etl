--
-- DWH Northwind, Data vault
--

DROP TABLE IF EXISTS s_categories;
DROP TABLE IF EXISTS s_products;
DROP TABLE IF EXISTS s_suppliers;
DROP TABLE IF EXISTS s_shippers;
DROP TABLE IF EXISTS s_orders;
DROP TABLE IF EXISTS s_customers;
DROP TABLE IF EXISTS s_customer_demographics;
DROP TABLE IF EXISTS s_employees;
DROP TABLE IF EXISTS s_territories;
DROP TABLE IF EXISTS s_region;
DROP TABLE IF EXISTS l_s_products_orders;

DROP TABLE IF EXISTS l_categories_products;
DROP TABLE IF EXISTS l_suppliers_products;
DROP TABLE IF EXISTS l_products_orders;
DROP TABLE IF EXISTS l_shippers_orders;
DROP TABLE IF EXISTS l_customers_orders;
DROP TABLE IF EXISTS l_customer_demographics_customers;
DROP TABLE IF EXISTS l_employees_orders;
DROP TABLE IF EXISTS l_employees_territories;
DROP TABLE IF EXISTS l_employees_employees;
DROP TABLE IF EXISTS l_territories_region;

DROP TABLE IF EXISTS h_categories;
DROP TABLE IF EXISTS h_products;
DROP TABLE IF EXISTS h_suppliers;
DROP TABLE IF EXISTS h_shippers;
DROP TABLE IF EXISTS h_orders;
DROP TABLE IF EXISTS h_customers;
DROP TABLE IF EXISTS h_customer_demographics;
DROP TABLE IF EXISTS h_employees;
DROP TABLE IF EXISTS h_territories;
DROP TABLE IF EXISTS h_region;


--
-- Hubs 
--
CREATE TABLE h_categories (
	h_categories_rk bigint PRIMARY KEY,
    category_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE h_products (
	h_products_rk bigint PRIMARY KEY,
    product_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE h_suppliers (
	h_suppliers_rk bigint PRIMARY KEY,
    supplier_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE h_shippers (
	h_shippers_id bigint PRIMARY KEY,
    shipper_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE h_orders (
	h_orders_rk bigint PRIMARY KEY,
    order_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE h_customers (
	h_customers_rk bigint PRIMARY KEY,
    customer_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE h_customer_demographics (
	h_customer_demographics_rk bigint PRIMARY KEY,
    customer_type_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE h_employees (
	h_employees_rk bigint PRIMARY KEY,
    employee_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE h_territories (
	h_territories_rk bigint PRIMARY KEY,
    territory_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE h_region (
	h_region_rk bigint PRIMARY KEY,
    region_id smallint,
    source_system character varying(255),
    processed_dttm date
);



--
-- Links
-- 
CREATE TABLE l_categories_products (
	l_categories_products_rk bigint PRIMARY KEY,
	h_categories_rk bigint,
    h_products_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_categories_rk) REFERENCES h_categories,
    FOREIGN KEY (h_products_rk) REFERENCES h_products
);

CREATE TABLE l_suppliers_products (
	l_suppliers_products_rk bigint PRIMARY KEY,
	h_suppliers_rk bigint,
    h_products_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_suppliers_rk) REFERENCES h_suppliers,
    FOREIGN KEY (h_products_rk) REFERENCES h_products
);

CREATE TABLE l_products_orders (
	l_products_orders_rk bigint PRIMARY KEY,
	h_orders_rk bigint,
	h_products_rk bigint,    
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_orders_rk) REFERENCES h_orders,
    FOREIGN KEY (h_products_rk) REFERENCES h_products
);

CREATE TABLE l_shippers_orders (
	l_shippers_orders_rk bigint PRIMARY KEY,
	h_shippers_rk bigint,
    h_orders_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_shippers_rk) REFERENCES h_shippers,
    FOREIGN KEY (h_orders_rk) REFERENCES h_orders
);

CREATE TABLE l_customers_orders (
	l_customers_orders_rk bigint PRIMARY KEY,
	h_customers_rk bigint,
	h_orders_rk bigint,    
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_customers_rk) REFERENCES h_customers,
    FOREIGN KEY (h_orders_rk) REFERENCES h_orders
);

CREATE TABLE l_customer_demographics_customers (
	l_customer_demographics_customers_rk bigint PRIMARY KEY,
	h_customer_demographics_rk bigint,
	h_customers_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_customer_demographics_rk) REFERENCES h_customer_demographics,
    FOREIGN KEY (h_customers_rk) REFERENCES h_customers
);

CREATE TABLE l_employees_orders (
	l_employees_orders_rk bigint PRIMARY KEY,
	h_employees_rk bigint,
    h_orders_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_employees_rk) REFERENCES h_employees,
    FOREIGN KEY (h_orders_rk) REFERENCES h_orders
);

CREATE TABLE l_employees_territories (
	l_employees_territories_rk bigint PRIMARY KEY,
	h_employees_rk bigint,
	h_territories_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_employees_rk) REFERENCES h_employees,
    FOREIGN KEY (h_territories_rk) REFERENCES h_territories
);

CREATE TABLE l_employees_employees (
	l_employees_employees_rk bigint PRIMARY KEY,
	h_employees_rk bigint,
    h_employees_rk_reports_to bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_employees_rk) REFERENCES h_employees,
    FOREIGN KEY (h_employees_rk_reports_to) REFERENCES h_employees (h_employees_rk)
);

CREATE TABLE l_territories_region (
	l_territories_region_rk bigint PRIMARY KEY,
	h_territories_rk bigint,
   	h_region_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_territories_rk) REFERENCES h_territories,
    FOREIGN KEY (h_region_rk) REFERENCES h_region
);





--
-- Satellites
--


CREATE TABLE s_categories (
	h_categories_rk bigint,
    category_name character varying(15) NOT NULL,
    description text,
    picture bytea,
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_categories_rk) REFERENCES h_categories
);

CREATE TABLE s_customer_demographics (
	h_customer_demographics_rk bigint,
    customer_desc text,
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_customer_demographics_rk) REFERENCES h_customer_demographics
);

CREATE TABLE s_customers (
	h_customers_rk bigint,
    company_name character varying(40) NOT NULL,
    contact_name character varying(30),
    contact_title character varying(30),
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postal_code character varying(10),
    country character varying(15),
    phone character varying(24),
    fax character varying(24),
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_customers_rk) REFERENCES h_customers
);

CREATE TABLE s_employees (
	h_employees_rk bigint,
    last_name character varying(20) NOT NULL,
    first_name character varying(10) NOT NULL,
    title character varying(30),
    title_of_courtesy character varying(25),
    birth_date date,
    hire_date date,
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postal_code character varying(10),
    country character varying(15),
    home_phone character varying(24),
    extension character varying(4),
    photo bytea,
    notes text,
    photo_path character varying(255),
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_employees_rk) REFERENCES h_employees
);

CREATE TABLE s_suppliers (
	h_suppliers_rk bigint,
    company_name character varying(40) NOT NULL,
    contact_name character varying(30),
    contact_title character varying(30),
    address character varying(60),
    city character varying(15),
    region character varying(15),
    postal_code character varying(10),
    country character varying(15),
    phone character varying(24),
    fax character varying(24),
    homepage text,
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_suppliers_rk) REFERENCES h_suppliers
);

CREATE TABLE s_products (
	h_products_rk bigint,
    product_name character varying(40) NOT NULL,    
    quantity_per_unit character varying(20),
    unit_price real,
    units_in_stock smallint,
    units_on_order smallint,
    reorder_level smallint,
    discontinued integer NOT NULL,
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_products_rk) REFERENCES h_products
);

CREATE TABLE s_region (
	h_region_rk bigint,
    region_description bpchar NOT NULL,
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_region_rk) REFERENCES h_region
);

CREATE TABLE s_shippers (
	h_shippers_rk bigint,
    company_name character varying(40) NOT NULL,
    phone character varying(24),
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_shippers_rk) REFERENCES h_shippers
);

CREATE TABLE s_orders (
	h_orders_rk bigint,
    order_date date,
    required_date date,
    shipped_date date,    
    freight real,
    ship_name character varying(40),
    ship_address character varying(60),
    ship_city character varying(15),
    ship_region character varying(15),
    ship_postal_code character varying(10),
    ship_country character varying(15),
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_orders_rk) REFERENCES h_orders
);

CREATE TABLE s_territories (
	h_territories_rk bigint,
    territory_description bpchar NOT NULL,
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (h_territories_rk) REFERENCES h_territories
);

CREATE TABLE l_s_products_orders (
	l_products_orders_rk bigint,
    unit_price real NOT NULL,
    quantity smallint NOT NULL,
    discount real NOT NULL,
    valid_from_dttm date,
    valid_to_dttm date,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (l_products_orders_rk) REFERENCES l_products_orders
);
