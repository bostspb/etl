--
-- DWH Northwind, Anchor modeling
--

DROP TABLE IF EXISTS attr_categories_name;
DROP TABLE IF EXISTS attr_categories_description;
DROP TABLE IF EXISTS attr_categories_picture;
DROP TABLE IF EXISTS attr_customer_demographics_desc;
DROP TABLE IF EXISTS attr_customers_company_name;
DROP TABLE IF EXISTS attr_customers_contact_name;
DROP TABLE IF EXISTS attr_customers_contact_title;
DROP TABLE IF EXISTS attr_customers_address;
DROP TABLE IF EXISTS attr_customers_city;
DROP TABLE IF EXISTS attr_customers_region;
DROP TABLE IF EXISTS attr_customers_postal_code;
DROP TABLE IF EXISTS attr_customers_country;
DROP TABLE IF EXISTS attr_customers_phone;
DROP TABLE IF EXISTS attr_customers_fax;
DROP TABLE IF EXISTS attr_employees_last_name;
DROP TABLE IF EXISTS attr_employees_first_name;
DROP TABLE IF EXISTS attr_employees_title;
DROP TABLE IF EXISTS attr_employees_title_of_courtesy;
DROP TABLE IF EXISTS attr_employees_birth_date;
DROP TABLE IF EXISTS attr_employees_hire_date;
DROP TABLE IF EXISTS attr_employees_address;
DROP TABLE IF EXISTS attr_employees_city;
DROP TABLE IF EXISTS attr_employees_region;
DROP TABLE IF EXISTS attr_employees_postal_code;
DROP TABLE IF EXISTS attr_employees_country;
DROP TABLE IF EXISTS attr_employees_home_phone;
DROP TABLE IF EXISTS attr_employees_extension;
DROP TABLE IF EXISTS attr_employees_photo;
DROP TABLE IF EXISTS attr_employees_notes;
DROP TABLE IF EXISTS attr_employees_photo_path;
DROP TABLE IF EXISTS attr_suppliers_company_name;
DROP TABLE IF EXISTS attr_suppliers_contact_name;
DROP TABLE IF EXISTS attr_suppliers_contact_title;
DROP TABLE IF EXISTS attr_suppliers_address;
DROP TABLE IF EXISTS attr_suppliers_city;
DROP TABLE IF EXISTS attr_suppliers_region;
DROP TABLE IF EXISTS attr_suppliers_postal_code;
DROP TABLE IF EXISTS attr_suppliers_country;
DROP TABLE IF EXISTS attr_suppliers_phone;
DROP TABLE IF EXISTS attr_suppliers_fax;
DROP TABLE IF EXISTS attr_suppliers_homepage;
DROP TABLE IF EXISTS attr_products_name;
DROP TABLE IF EXISTS attr_products_quantity_per_unit;
DROP TABLE IF EXISTS attr_products_unit_price;
DROP TABLE IF EXISTS attr_products_units_in_stock;
DROP TABLE IF EXISTS attr_products_units_on_order;
DROP TABLE IF EXISTS attr_products_reorder_level;
DROP TABLE IF EXISTS attr_products_discontinued;
DROP TABLE IF EXISTS attr_region_description;
DROP TABLE IF EXISTS attr_shippers_company_name;
DROP TABLE IF EXISTS attr_shippers_phone;
DROP TABLE IF EXISTS attr_orders_order_date;
DROP TABLE IF EXISTS attr_orders_required_date;
DROP TABLE IF EXISTS attr_orders_shipped_date;
DROP TABLE IF EXISTS attr_orders_freight;
DROP TABLE IF EXISTS attr_orders_ship_name;
DROP TABLE IF EXISTS attr_orders_ship_address;
DROP TABLE IF EXISTS attr_orders_ship_city;
DROP TABLE IF EXISTS attr_orders_ship_region;
DROP TABLE IF EXISTS attr_orders_ship_postal_code;
DROP TABLE IF EXISTS attr_orders_ship_country;
DROP TABLE IF EXISTS attr_territories;
DROP TABLE IF EXISTS attr_order_details_unit_price;
DROP TABLE IF EXISTS attr_order_details_quantity;
DROP TABLE IF EXISTS attr_order_details_discount;

DROP TABLE IF EXISTS t_categories_products;
DROP TABLE IF EXISTS t_suppliers_products;
DROP TABLE IF EXISTS t_products_order_details;
DROP TABLE IF EXISTS t_order_details_orders;
DROP TABLE IF EXISTS t_shippers_orders;
DROP TABLE IF EXISTS t_customers_orders;
DROP TABLE IF EXISTS t_customer_demographics_customers;
DROP TABLE IF EXISTS t_employees_orders;
DROP TABLE IF EXISTS t_employees_territories;
DROP TABLE IF EXISTS t_employees_employees;
DROP TABLE IF EXISTS t_territories_region;

DROP TABLE IF EXISTS a_categories;
DROP TABLE IF EXISTS a_products;
DROP TABLE IF EXISTS a_suppliers;
DROP TABLE IF EXISTS a_shippers;
DROP TABLE IF EXISTS a_orders;
DROP TABLE IF EXISTS a_customers;
DROP TABLE IF EXISTS a_customer_demographics;
DROP TABLE IF EXISTS a_employees;
DROP TABLE IF EXISTS a_territories;
DROP TABLE IF EXISTS a_region;
DROP TABLE IF EXISTS a_order_details;


--
-- Anchors
--
CREATE TABLE a_categories (
	a_categories_rk bigint PRIMARY KEY,
    category_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE a_products (
	a_products_rk bigint PRIMARY KEY,
    product_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE a_suppliers (
	a_suppliers_rk bigint PRIMARY KEY,
    supplier_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE a_shippers (
	a_shippers_id bigint PRIMARY KEY,
    shipper_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE a_orders (
	a_orders_rk bigint PRIMARY KEY,
    order_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE a_customers (
	a_customers_rk bigint PRIMARY KEY,
    customer_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE a_customer_demographics (
	a_customer_demographics_rk bigint PRIMARY KEY,
    customer_type_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE a_employees (
	a_employees_rk bigint PRIMARY KEY,
    employee_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE a_territories (
	a_territories_rk bigint PRIMARY KEY,
    territory_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE a_region (
	a_region_rk bigint PRIMARY KEY,
    region_id smallint,
    source_system character varying(255),
    processed_dttm date
);

CREATE TABLE a_order_details (
	a_order_details_rk bigint PRIMARY KEY,	
	order_id smallint,
	product_id smallint,
    source_system character varying(255),
    processed_dttm date
);



--
-- Ties
-- 
CREATE TABLE t_categories_products (
	t_categories_products_rk bigint PRIMARY KEY,
	a_categories_rk bigint,
    a_products_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_categories_rk) REFERENCES a_categories,
    FOREIGN KEY (a_products_rk) REFERENCES a_products
);

CREATE TABLE t_suppliers_products (
	t_suppliers_products_rk bigint PRIMARY KEY,
	a_suppliers_rk bigint,
    a_products_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers,
    FOREIGN KEY (a_products_rk) REFERENCES a_products
);

CREATE TABLE t_products_order_details (
	t_products_order_details_rk bigint PRIMARY KEY,
	a_products_rk bigint, 
	a_order_details_rk bigint,	
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_order_details_rk) REFERENCES a_order_details,
    FOREIGN KEY (a_products_rk) REFERENCES a_products
);

CREATE TABLE t_order_details_orders (
	t_order_details_orders_rk bigint PRIMARY KEY,	
	a_order_details_rk bigint,	
	a_orders_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders,
    FOREIGN KEY (a_order_details_rk) REFERENCES a_order_details
);

CREATE TABLE t_shippers_orders (
	t_shippers_orders_rk bigint PRIMARY KEY,
	a_shippers_rk bigint,
    a_orders_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_shippers_rk) REFERENCES a_shippers,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE t_customers_orders (
	t_customers_orders_rk bigint PRIMARY KEY,
	a_customers_rk bigint,
	a_orders_rk bigint,    
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE t_customer_demographics_customers (
	t_customer_demographics_customers_rk bigint PRIMARY KEY,
	a_customer_demographics_rk bigint,
	a_customers_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_customer_demographics_rk) REFERENCES a_customer_demographics,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE t_employees_orders (
	t_employees_orders_rk bigint PRIMARY KEY,
	a_employees_rk bigint,
    a_orders_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE t_employees_territories (
	t_employees_territories_rk bigint PRIMARY KEY,
	a_employees_rk bigint,
	a_territories_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees,
    FOREIGN KEY (a_territories_rk) REFERENCES a_territories
);

CREATE TABLE t_employees_employees (
	t_employees_employees_rk bigint PRIMARY KEY,
	a_employees_rk bigint,
    a_employees_rk_reports_to bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees,
    FOREIGN KEY (a_employees_rk_reports_to) REFERENCES a_employees (a_employees_rk)
);

CREATE TABLE t_territories_region (
	t_territories_region_rk bigint PRIMARY KEY,
	a_territories_rk bigint,
   	a_region_rk bigint,
    source_system character varying(255),
    processed_dttm date,
    FOREIGN KEY (a_territories_rk) REFERENCES a_territories,
    FOREIGN KEY (a_region_rk) REFERENCES a_region
);





--
-- Attributes
--
CREATE TABLE attr_categories_name (
	a_categories_rk bigint,
    category_name character varying(15) NOT NULL,    
    valid_from_dttm date,    
    processed_dttm date,
    FOREIGN KEY (a_categories_rk) REFERENCES a_categories
);

CREATE TABLE attr_categories_description (
	a_categories_rk bigint,    
    description text,    
    valid_from_dttm date,    
    processed_dttm date,
    FOREIGN KEY (a_categories_rk) REFERENCES a_categories
);

CREATE TABLE attr_categories_picture (
	a_categories_rk bigint,    
    picture bytea,
    valid_from_dttm date,    
    processed_dttm date,
    FOREIGN KEY (a_categories_rk) REFERENCES a_categories
);

CREATE TABLE attr_customer_demographics_desc (
	a_customer_demographics_rk bigint,
    customer_desc text,
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customer_demographics_rk) REFERENCES a_customer_demographics
);

CREATE TABLE attr_customers_company_name (
	a_customers_rk bigint,
    company_name character varying(40) NOT NULL,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE attr_customers_contact_name (
	a_customers_rk bigint,    
    contact_name character varying(30),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE attr_customers_contact_title (
	a_customers_rk bigint,    
    contact_title character varying(30),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE attr_customers_address (
	a_customers_rk bigint,    
    address character varying(60),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE attr_customers_city (
	a_customers_rk bigint,    
    city character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE attr_customers_region (
	a_customers_rk bigint,    
    region character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE attr_customers_postal_code (
	a_customers_rk bigint,    
    postal_code character varying(10),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE attr_customers_country (
	a_customers_rk bigint,    
    country character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE attr_customers_phone (
	a_customers_rk bigint,    
    phone character varying(24),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE attr_customers_fax (
	a_customers_rk bigint,    
    fax character varying(24),
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_customers_rk) REFERENCES a_customers
);

CREATE TABLE attr_employees_last_name (
	a_employees_rk bigint,
    last_name character varying(20) NOT NULL,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_first_name (
	a_employees_rk bigint,    
    first_name character varying(10) NOT NULL,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_title (
	a_employees_rk bigint,    
    title character varying(30),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_title_of_courtesy (
	a_employees_rk bigint,    
    title_of_courtesy character varying(25),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_birth_date (
	a_employees_rk bigint,    
    birth_date date,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_hire_date (
	a_employees_rk bigint,    
    hire_date date,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_address (
	a_employees_rk bigint,    
    address character varying(60),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_city (
	a_employees_rk bigint,    
    city character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_region (
	a_employees_rk bigint,    
    region character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_postal_code (
	a_employees_rk bigint,    
    postal_code character varying(10),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_country (
	a_employees_rk bigint,    
    country character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_home_phone (
	a_employees_rk bigint,    
    home_phone character varying(24),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_extension (
	a_employees_rk bigint,    
    extension character varying(4),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_photo (
	a_employees_rk bigint,    
    photo bytea,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_notes (
	a_employees_rk bigint,    
    notes text,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_employees_photo_path (
	a_employees_rk bigint,    
    photo_path character varying(255),
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_employees_rk) REFERENCES a_employees
);

CREATE TABLE attr_suppliers_company_name (
	a_suppliers_rk bigint,
    company_name character varying(40) NOT NULL,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_suppliers_contact_name (
	a_suppliers_rk bigint,    
    contact_name character varying(30),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_suppliers_contact_title (
	a_suppliers_rk bigint,    
    contact_title character varying(30),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_suppliers_address (
	a_suppliers_rk bigint,    
    address character varying(60),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_suppliers_city (
	a_suppliers_rk bigint,    
    city character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_suppliers_region (
	a_suppliers_rk bigint,    
    region character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_suppliers_postal_code (
	a_suppliers_rk bigint,    
    postal_code character varying(10),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_suppliers_country (
	a_suppliers_rk bigint,    
    country character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_suppliers_phone (
	a_suppliers_rk bigint,    
    phone character varying(24),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_suppliers_fax (
	a_suppliers_rk bigint,    
    fax character varying(24),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_suppliers_homepage (
	a_suppliers_rk bigint,    
    homepage text,
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_suppliers_rk) REFERENCES a_suppliers
);

CREATE TABLE attr_products_name (
	a_products_rk bigint,
    product_name character varying(40) NOT NULL,
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_products_rk) REFERENCES a_products
);

CREATE TABLE attr_products_quantity_per_unit (
	a_products_rk bigint,      
    quantity_per_unit character varying(20),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_products_rk) REFERENCES a_products
);

CREATE TABLE attr_products_unit_price (
	a_products_rk bigint,    
    unit_price real,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_products_rk) REFERENCES a_products
);

CREATE TABLE attr_products_units_in_stock (
	a_products_rk bigint,    
    units_in_stock smallint,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_products_rk) REFERENCES a_products
);

CREATE TABLE attr_products_units_on_order (
	a_products_rk bigint,    
    units_on_order smallint,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_products_rk) REFERENCES a_products
);

CREATE TABLE attr_products_reorder_level (
	a_products_rk bigint,    
    reorder_level smallint,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_products_rk) REFERENCES a_products
);

CREATE TABLE attr_products_discontinued (
	a_products_rk bigint,    
    discontinued integer NOT NULL,
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_products_rk) REFERENCES a_products
);

CREATE TABLE attr_region_description (
	a_region_rk bigint,
    region_description bpchar NOT NULL,
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_region_rk) REFERENCES a_region
);

CREATE TABLE attr_shippers_company_name (
	a_shippers_rk bigint,
    company_name character varying(40) NOT NULL,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_shippers_rk) REFERENCES a_shippers
);

CREATE TABLE attr_shippers_phone (
	a_shippers_rk bigint,
    phone character varying(24),
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_shippers_rk) REFERENCES a_shippers
);

CREATE TABLE attr_orders_order_date (
	a_orders_rk bigint,
    order_date date,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE attr_orders_required_date (
	a_orders_rk bigint,    
    required_date date,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE attr_orders_shipped_date (
	a_orders_rk bigint,    
    shipped_date date,
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE attr_orders_freight (
	a_orders_rk bigint,     
    freight real,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE attr_orders_ship_name (
	a_orders_rk bigint,    
    ship_name character varying(40),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE attr_orders_ship_address (
	a_orders_rk bigint,    
    ship_address character varying(60),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE attr_orders_ship_city (
	a_orders_rk bigint,    
    ship_city character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE attr_orders_ship_region (
	a_orders_rk bigint,    
    ship_region character varying(15),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE attr_orders_ship_postal_code (
	a_orders_rk bigint,    
    ship_postal_code character varying(10),    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE attr_orders_ship_country (
	a_orders_rk bigint,    
    ship_country character varying(15),
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_orders_rk) REFERENCES a_orders
);

CREATE TABLE attr_territories (
	a_territories_rk bigint,
    territory_description bpchar NOT NULL,
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_territories_rk) REFERENCES a_territories
);

CREATE TABLE attr_order_details_unit_price (
	a_order_details_rk bigint,
    unit_price real NOT NULL,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_order_details_rk) REFERENCES a_order_details
);

CREATE TABLE attr_order_details_quantity (
	a_order_details_rk bigint,    
    quantity smallint NOT NULL,    
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_order_details_rk) REFERENCES a_order_details
);

CREATE TABLE attr_order_details_discount (
	a_order_details_rk bigint,    
    discount real NOT NULL,
    valid_from_dttm date,
    processed_dttm date,
    FOREIGN KEY (a_order_details_rk) REFERENCES a_order_details
);
