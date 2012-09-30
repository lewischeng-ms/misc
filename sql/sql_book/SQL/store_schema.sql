-- The SQL*Plus script store_schema.sql performs the following:
--   1. Creates store user
--   2. Creates the database tables, PL/SQL packages, etc.
--   3. Populates the database tables with example data

-- This script should be run by the system user (or the DBA)
CONNECT / as sysdba;

-- drop store user
DROP USER store CASCADE;

-- create store user
CREATE USER store IDENTIFIED BY "123";

-- allow store user to connect and create database objects
GRANT connect, resource TO store;

-- connect as store user
CONNECT store/123;

alter session set nls_language='AMERICAN';

-- create the tables
CREATE TABLE customers (
  customer_id INTEGER
    CONSTRAINT customers_pk PRIMARY KEY,
  first_name VARCHAR2(10) NOT NULL,
  last_name VARCHAR2(10) NOT NULL,
  dob DATE,
  phone VARCHAR2(12)
);

CREATE TABLE product_types (
  product_type_id INTEGER
    CONSTRAINT product_types_pk PRIMARY KEY,
  name VARCHAR2(10) NOT NULL
);

CREATE TABLE products (
  product_id INTEGER
    CONSTRAINT products_pk PRIMARY KEY,
  product_type_id INTEGER
    CONSTRAINT products_fk_product_types
    REFERENCES product_types(product_type_id),
  name VARCHAR2(30) NOT NULL,
  description VARCHAR2(50),
  price NUMBER(5, 2)
);

CREATE TABLE purchases (
  product_id INTEGER
    CONSTRAINT purchases_fk_products
    REFERENCES products(product_id),
  customer_id INTEGER
    CONSTRAINT purchases_fk_customers
    REFERENCES customers(customer_id),
  quantity INTEGER NOT NULL,
  CONSTRAINT purchases_pk PRIMARY KEY (product_id, customer_id)
);

CREATE TABLE employees (
  employee_id INTEGER
    CONSTRAINT employees_pk PRIMARY KEY,
  manager_id INTEGER,
  first_name VARCHAR2(10) NOT NULL,
  last_name VARCHAR2(10) NOT NULL,
  title VARCHAR2(20),
  salary NUMBER(6, 0)
);

CREATE TABLE salary_grades (
  salary_grade_id INTEGER
    CONSTRAINT salary_grade_pk PRIMARY KEY,
  low_salary NUMBER(6, 0),
  high_salary NUMBER(6, 0)
);

CREATE TABLE purchases_with_timestamp (
  product_id INTEGER REFERENCES products(product_id),
  customer_id INTEGER REFERENCES customers(customer_id),
  made_on TIMESTAMP(4)
);

CREATE TABLE purchases_timestamp_with_tz (
  product_id INTEGER REFERENCES products(product_id),
  customer_id INTEGER REFERENCES customers(customer_id),
  made_on TIMESTAMP(4) WITH TIME ZONE
);

CREATE TABLE purchases_with_local_tz (
  product_id INTEGER REFERENCES products(product_id),
  customer_id INTEGER REFERENCES customers(customer_id),
  made_on TIMESTAMP(4) WITH LOCAL TIME ZONE
);

CREATE TABLE coupons (
  coupon_id INTEGER CONSTRAINT coupons_pk PRIMARY KEY,
  name VARCHAR2(30) NOT NULL,
  duration INTERVAL YEAR(3) TO MONTH
);

CREATE TABLE promotions (
  promotion_id INTEGER CONSTRAINT promotions_pk PRIMARY KEY,
  name VARCHAR2(30) NOT NULL,
  duration INTERVAL DAY(3) TO SECOND (4)
);

CREATE TABLE order_status (
  order_status_id INTEGER
    CONSTRAINT default_example_pk PRIMARY KEY,
  status VARCHAR2(20) DEFAULT 'Order placed' NOT NULL,
  last_modified DATE DEFAULT SYSDATE
);

CREATE TABLE product_changes (
  product_id INTEGER
    CONSTRAINT prod_changes_pk PRIMARY KEY,
  product_type_id INTEGER
    CONSTRAINT prod_changes_fk_product_types
    REFERENCES product_types(product_type_id),
  name VARCHAR2(30) NOT NULL,
  description VARCHAR2(50),
  price NUMBER(5, 2)
);

CREATE TABLE more_products (
  prd_id INTEGER PRIMARY KEY,
  prd_type_id INTEGER
    REFERENCES product_types(product_type_id),
  name VARCHAR2(30) NOT NULL,
  available CHAR(1)
);

CREATE TABLE more_employees (
  employee_id INTEGER
    CONSTRAINT more_employees_pk PRIMARY KEY,
  manager_id INTEGER
    CONSTRAINT more_empl_fk_fk_more_empl 
    REFERENCES more_employees(employee_id),
  first_name VARCHAR2(10) NOT NULL,
  last_name VARCHAR2(10) NOT NULL,
  title VARCHAR2(20),
  salary NUMBER(6, 0)
);

CREATE TABLE divisions (
  division_id CHAR(3)
    CONSTRAINT divisions_pk PRIMARY KEY,
  name VARCHAR2(15) NOT NULL
);

CREATE TABLE jobs (
  job_id CHAR(3)
    CONSTRAINT jobs_pk PRIMARY KEY,
  name VARCHAR2(20) NOT NULL
);

CREATE TABLE employees2 (
  employee_id INTEGER
    CONSTRAINT employees2_pk PRIMARY KEY,
  division_id CHAR(3)
    CONSTRAINT employees2_fk_divisions
    REFERENCES divisions(division_id),
  job_id CHAR(3) REFERENCES jobs(job_id),
  first_name VARCHAR2(10) NOT NULL,
  last_name VARCHAR2(10) NOT NULL,
  salary NUMBER(6, 0)
);

CREATE TABLE all_sales (
  year INTEGER NOT NULL,
  month INTEGER NOT NULL,
  prd_type_id INTEGER
    CONSTRAINT all_sales_fk_product_types
    REFERENCES product_types(product_type_id),
  emp_id INTEGER
    CONSTRAINT all_sales_fk_employees2
    REFERENCES employees2(employee_id),
  amount NUMBER(8, 2),
  CONSTRAINT all_sales_pk PRIMARY KEY (
    year, month, prd_type_id, emp_id
  )
);

CREATE TABLE product_price_audit (
  product_id INTEGER
    CONSTRAINT price_audit_fk_products
    REFERENCES products(product_id),
  old_price  NUMBER(5, 2),
  new_price  NUMBER(5, 2)
);

CREATE TABLE reg_exps (
  id NUMBER
    CONSTRAINT reg_exps_pk PRIMARY KEY,
  text VARCHAR2(512) NOT NULL
);

-- create the PL/SQL functions, procedures, packages and triggers

CREATE OR REPLACE PROCEDURE update_product_price(
  p_product_id IN products.product_id%TYPE,
  p_factor     IN NUMBER
) AS
  v_product_count INTEGER;
BEGIN
  -- count the number of products with the
  -- supplied product_id (should be 1 if the product exists)
  SELECT COUNT(*)
  INTO v_product_count
  FROM products
  WHERE product_id = p_product_id;

  -- if the product exists (v_product_count = 1) then
  -- update that product's price
  IF v_product_count = 1 THEN
    UPDATE products
    SET price = price * p_factor
    WHERE product_id = p_product_id;
    COMMIT;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
END update_product_price;
/

CREATE OR REPLACE FUNCTION circle_area (
  p_radius IN NUMBER
) RETURN NUMBER AS
  v_pi   NUMBER := 3.1415926;
  v_area NUMBER;
BEGIN
  v_area := v_pi * POWER(p_radius, 2);
  RETURN v_area;
END circle_area;
/

CREATE OR REPLACE FUNCTION average_product_price (
  p_product_type_id IN INTEGER
) RETURN NUMBER AS
  v_average_product_price NUMBER;
BEGIN
  SELECT AVG(price)
  INTO v_average_product_price
  FROM products
  WHERE product_type_id = p_product_type_id;
  RETURN v_average_product_price;
END average_product_price;
/

CREATE OR REPLACE PACKAGE product_package AS
  TYPE t_ref_cursor IS REF CURSOR;
  FUNCTION get_products_ref_cursor RETURN t_ref_cursor;
  PROCEDURE update_product_price (
    p_product_id IN products.product_id%TYPE,
    p_factor     IN NUMBER
  );
END product_package;
/

CREATE OR REPLACE PACKAGE BODY product_package AS
  FUNCTION get_products_ref_cursor
  RETURN t_ref_cursor IS
    products_ref_cursor t_ref_cursor;
  BEGIN
    -- get the REF CURSOR
    OPEN products_ref_cursor FOR
      SELECT product_id, name, price
      FROM products;
    -- return the REF CURSOR
    RETURN products_ref_cursor;
  END get_products_ref_cursor;

  PROCEDURE update_product_price (
    p_product_id IN products.product_id%TYPE,
    p_factor     IN NUMBER
  ) AS
    v_product_count INTEGER;
  BEGIN
    -- count the number of products with the
    -- supplied product_id (should be 1 if the product exists)
    SELECT COUNT(*)
    INTO v_product_count
    FROM products
    WHERE product_id = p_product_id;
    -- if the product exists (v_product_count = 1) then
    -- update that product's price
    IF v_product_count = 1 THEN
      UPDATE products
      SET price = price * p_factor
      WHERE product_id = p_product_id;
      COMMIT;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- perform a rollback when an exception occurs
      ROLLBACK;
  END update_product_price;
END product_package;
/

CREATE OR REPLACE TRIGGER before_product_price_update
BEFORE UPDATE OF price
ON products
FOR EACH ROW WHEN (new.price < old.price * 0.75)
BEGIN
  dbms_output.put_line('product_id = ' || :old.product_id);
  dbms_output.put_line('Old price = ' || :old.price);
  dbms_output.put_line('New price = ' || :new.price);
  dbms_output.put_line('The price reduction is more than 25%');

  -- insert row into the product_price_audit table
  INSERT INTO product_price_audit (
    product_id, old_price, new_price
  ) VALUES (
    :old.product_id, :old.price, :new.price
  );
END before_product_price_update;
/

-- insert sample data into customers table

INSERT INTO customers (
  customer_id, first_name, last_name, dob, phone
) VALUES (
  1, 'John', 'Brown', '01-JAN-1965', '800-555-1211'
);

INSERT INTO customers (
  customer_id, first_name, last_name, dob, phone
) VALUES (
  2, 'Cynthia', 'Green', '05-FEB-1968', '800-555-1212'
);

INSERT INTO customers (
  customer_id, first_name, last_name, dob, phone
) VALUES (
  3, 'Steve', 'White', '16-MAR-1971', '800-555-1213'
);

INSERT INTO customers (
  customer_id, first_name, last_name, dob, phone
) VALUES (
  4, 'Gail', 'Black', NULL, '800-555-1214'
);

INSERT INTO customers (
  customer_id, first_name, last_name, dob, phone
) VALUES (
  5, 'Doreen', 'Blue', '20-MAY-1970', NULL
);

-- commit the transaction
COMMIT;

-- insert sample data into product_types table

INSERT INTO product_types (
  product_type_id, name
) VALUES (
  1, 'Book'
);

INSERT INTO product_types (
  product_type_id, name
) VALUES (
  2, 'Video'
);

INSERT INTO product_types (
  product_type_id, name
) VALUES (
  3, 'DVD'
);

INSERT INTO product_types (
  product_type_id, name
) VALUES (
  4, 'CD'
);

INSERT INTO product_types (
  product_type_id, name
) VALUES (
  5, 'Magazine'
);

-- commit the transaction
COMMIT;

-- insert sample data into products table

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  1, 1, 'Modern Science', 'A description of modern science', 19.95
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  2, 1, 'Chemistry', 'Introduction to Chemistry', 30.00
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  3, 2, 'Supernova', 'A star explodes', 25.99
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  4, 2, 'Tank War', 'Action movie about a future war', 13.95
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  5, 2, 'Z Files', 'Series on mysterious activities', 49.99
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  6, 2, '2412: The Return', 'Aliens return', 14.95
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
)
VALUES (
  7, 3, 'Space Force 9', 'Adventures of heroes', 13.49
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  8, 3, 'From Another Planet', 'Alien from another planet lands on Earth', 12.99
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  9, 4, 'Classical Music', 'The best classical music', 10.99
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  10, 4, 'Pop 3', 'The best popular music', 15.99
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  11, 4, 'Creative Yell', 'Debut album', 14.99
);

INSERT INTO products (
  product_id, product_type_id, name, description, price
) VALUES (
  12, NULL, 'My Front Line', 'Their greatest hits', 13.49
);

-- commit the transaction
COMMIT;

-- insert sample data into purchases table

INSERT INTO purchases (
  product_id, customer_id, quantity
) VALUES (
  1, 1, 1
);

INSERT INTO purchases (
  product_id, customer_id, quantity
) VALUES (
  2, 1, 3
);

INSERT INTO purchases (
  product_id, customer_id, quantity
) VALUES (
  1, 4, 1
);

INSERT INTO purchases (
  product_id, customer_id, quantity
) VALUES (
  2, 2, 1
);

INSERT INTO purchases (
  product_id, customer_id, quantity
) VALUES (
  1, 3, 1
);

INSERT INTO purchases (
  product_id, customer_id, quantity
) VALUES (
  1, 2, 2
);

INSERT INTO purchases (
  product_id, customer_id, quantity
) VALUES (
  2, 3, 1
);

INSERT INTO purchases (
  product_id, customer_id, quantity
) VALUES (
  2, 4, 1
);

INSERT INTO purchases (
  product_id, customer_id, quantity
) VALUES (
  3, 3, 1
);

-- commit the transaction
COMMIT;

-- insert sample data into employees table

INSERT INTO employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  1, NULL, 'James', 'Smith', 'CEO', 800000
);

INSERT INTO employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  2, 1, 'Ron', 'Johnson', 'Sales Manager', 600000
);

INSERT INTO employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  3, 2, 'Fred', 'Hobbs', 'Salesperson', 150000
);

INSERT INTO employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  4, 2, 'Susan', 'Jones', 'Salesperson', 500000
);

-- commit the transaction
COMMIT;

-- insert sample data into salary_grade table

INSERT INTO salary_grades (
  salary_grade_id, low_salary, high_salary
) VALUES (
  1, 1, 250000
);

INSERT INTO salary_grades (
  salary_grade_id, low_salary, high_salary
) VALUES (
  2, 250001, 500000
);

INSERT INTO salary_grades (
  salary_grade_id, low_salary, high_salary
) VALUES (
  3, 500001, 750000
);

INSERT INTO salary_grades (
  salary_grade_id, low_salary, high_salary
) VALUES (
  4, 750001, 999999
);

-- commit the transaction
COMMIT;

-- insert sample data into purchases_with_timestamp table

INSERT INTO purchases_with_timestamp (
  product_id, customer_id, made_on
) VALUES (
  1, 1, TIMESTAMP '2005-05-13 07:15:31.1234'
);

-- commit the transaction
COMMIT;

-- insert sample data into purchases_with_tz table

INSERT INTO purchases_timestamp_with_tz (
  product_id, customer_id, made_on
) VALUES (
  1, 1, TIMESTAMP '2005-05-13 07:15:31.1234 -07:00'
);

INSERT INTO purchases_timestamp_with_tz (
  product_id, customer_id, made_on
) VALUES (
  1, 2, TIMESTAMP '2005-05-13 07:15:31.1234 PST'
);

-- commit the transaction
COMMIT;

-- insert sample data into purchases_with_local_tz table

INSERT INTO purchases_with_local_tz (
  product_id, customer_id, made_on
) VALUES (
  1, 1, TIMESTAMP '2005-05-13 07:15:30 EST'
);

-- commit the transaction
COMMIT;

-- insert sample data into coupons table

INSERT INTO coupons (
  coupon_id, name, duration
) VALUES (
  1, '$1 off Z Files', INTERVAL '1' YEAR
);

INSERT INTO coupons (
  coupon_id, name, duration
) VALUES (
  2, '$2 off Pop 3', INTERVAL '11' MONTH
);

INSERT INTO coupons (
  coupon_id, name, duration
) VALUES (
  3, '$3 off Modern Science', INTERVAL '14' MONTH
);

INSERT INTO coupons (
  coupon_id, name, duration
) VALUES (
  4, '$2 off Tank War', INTERVAL '1-3' YEAR TO MONTH
);

INSERT INTO coupons (
  coupon_id, name, duration
) VALUES (
  5, '$1 off Chemistry', INTERVAL '0-5' YEAR TO MONTH
);

INSERT INTO coupons (
  coupon_id, name, duration
) VALUES (
  6, '$2 off Creative Yell', INTERVAL '123' YEAR(3)
);

-- commit the transaction
COMMIT;

-- insert sample data into promotions table

INSERT INTO promotions (
  promotion_id, name, duration
) VALUES (
  1, '10% off Z Files', INTERVAL '3' DAY
);

INSERT INTO promotions (
  promotion_id, name, duration
) VALUES (
  2, '20% off Pop 3', INTERVAL '2' HOUR
);

INSERT INTO promotions (
  promotion_id, name, duration
) VALUES (
  3, '30% off Modern Science', INTERVAL '25' MINUTE
);

INSERT INTO promotions (
  promotion_id, name, duration
) VALUES (
  4, '20% off Tank War', INTERVAL '45' SECOND
);

INSERT INTO promotions (
  promotion_id, name, duration
) VALUES (
  5, '10% off Chemistry', INTERVAL '3 2:25' DAY TO MINUTE
);

INSERT INTO promotions (
  promotion_id, name, duration
) VALUES (
  6, '20% off Creative Yell', INTERVAL '3 2:25:45' DAY TO SECOND
);

INSERT INTO promotions (
  promotion_id, name, duration
) VALUES (
  7, '15% off My Front Line', INTERVAL '123 2:25:45.12' DAY(3) TO SECOND(2)
);

-- commit the transaction
COMMIT;

-- insert sample data into order_status table

INSERT INTO order_status (
  order_status_id
) VALUES (
  1
);

INSERT INTO order_status (
  order_status_id, status, last_modified
) VALUES (
  2, 'Order shipped', '10-JUN-2004'
);

-- commit the transaction
COMMIT;

-- insert sample data into product_changes table

INSERT INTO product_changes (
  product_id, product_type_id, name, description, price
) VALUES (
  1, 1, 'Modern Science', 'A description of modern science', 40.00
);

INSERT INTO product_changes (
  product_id, product_type_id, name, description, price
) VALUES (
  2, 1, 'New Chemistry', 'Introduction to Chemistry', 35.00
);

INSERT INTO product_changes (
  product_id, product_type_id, name, description, price
) VALUES (
  3, 1, 'Supernova', 'A star explodes', 25.99
);

INSERT INTO product_changes (
  product_id, product_type_id, name, description, price
) VALUES (
  13, 2, 'Lunar Landing', 'Documentary', 15.99
);

INSERT INTO product_changes (
  product_id, product_type_id, name, description, price
) VALUES (
  14, 2, 'Submarine', 'Documentary', 15.99
);

INSERT INTO product_changes (
  product_id, product_type_id, name, description, price
) VALUES (
  15, 2, 'Airplane', 'Documentary', 15.99
);

-- commit the transaction
COMMIT;

-- insert sample data into more_products table

INSERT INTO more_products (
  prd_id, prd_type_id, name, available
) VALUES (
  1, 1, 'Modern Science', 'Y'
);

INSERT INTO more_products (
  prd_id, prd_type_id, name, available
) VALUES (
  2, 1, 'Chemistry', 'Y'
);

INSERT INTO more_products (
  prd_id, prd_type_id, name, available
) VALUES (
  3, NULL, 'Supernova', 'N'
);

INSERT INTO more_products (
  prd_id, prd_type_id, name, available
) VALUES (
  4, 2, 'Lunar Landing', 'N'
);

INSERT INTO more_products (
  prd_id, prd_type_id, name, available
) VALUES (
  5, 2, 'Submarine', 'Y'
);

-- commit the transaction
COMMIT;

-- insert sample data into more_employees table

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  1, NULL, 'James', 'Smith', 'CEO', 800000
);
     
INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  2, 1, 'Ron', 'Johnson', 'Sales Manager', 600000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  3, 2, 'Fred', 'Hobbs', 'Sales Person', 200000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  4, 1, 'Susan', 'Jones', 'Support Manager', 500000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  5, 2, 'Rob', 'Green', 'Sales Person', 40000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  6, 4, 'Jane', 'Brown', 'Support Person', 45000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  7, 4, 'John', 'Grey', 'Support Manager', 30000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  8, 7, 'Jean', 'Blue', 'Support Person', 29000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  9, 6, 'Henry', 'Heyson', 'Support Person', 30000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  10, 1, 'Kevin', 'Black', 'Ops Manager', 100000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  11, 10, 'Keith', 'Long', 'Ops Person', 50000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  12, 10, 'Frank', 'Howard', 'Ops Person', 45000
);

INSERT INTO more_employees (
  employee_id, manager_id, first_name, last_name, title, salary
) VALUES (
  13, 10, 'Doreen', 'Penn', 'Ops Person', 47000
);

-- commit the transaction
COMMIT;

-- insert sample data into divisions table

INSERT INTO divisions (
  division_id, name
) VALUES (
  'SAL', 'Sales'
);

INSERT INTO divisions (
  division_id, name
) VALUES (
  'OPE', 'Operations'
);

INSERT INTO divisions (
  division_id, name
) VALUES (
  'SUP', 'Support'
);

INSERT INTO divisions (
  division_id, name
) VALUES (
  'BUS', 'Business'
);

-- commit the transaction
COMMIT;

-- insert sample data into jobs table

INSERT INTO jobs (
  job_id, name
) VALUES (
  'WOR', 'Worker'
);

INSERT INTO jobs (
  job_id, name
) VALUES (
  'MGR', 'Manager'
);

INSERT INTO jobs (
  job_id, name
) VALUES (
  'ENG', 'Engineer'
);

INSERT INTO jobs (
  job_id, name
) VALUES (
  'TEC', 'Technologist'
);

INSERT INTO jobs (
  job_id, name
) VALUES (
  'PRE', 'President'
);

-- commit the transaction
COMMIT;

-- insert sample data into employees2 table

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  1, 'BUS', 'PRE', 'James', 'Smith', 800000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  2, 'SAL', 'MGR', 'Ron', 'Johnson', 350000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  3, 'SAL', 'WOR', 'Fred', 'Hobbs', 140000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  4, 'SUP', 'MGR', 'Susan', 'Jones', 200000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  5, 'SAL', 'WOR', 'Rob', 'Green', 350000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  6, 'SUP', 'WOR', 'Jane', 'Brown', 200000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  7, 'SUP', 'MGR', 'John', 'Grey', 265000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  8, 'SUP', 'WOR', 'Jean', 'Blue', 110000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  9, 'SUP', 'WOR', 'Henry', 'Heyson', 125000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  10, 'OPE', 'MGR', 'Kevin', 'Black', 225000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  11, 'OPE', 'MGR', 'Keith', 'Long', 165000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  12, 'OPE', 'WOR', 'Frank', 'Howard', 125000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  13, 'OPE', 'WOR', 'Doreen', 'Penn', 145000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  14, 'BUS', 'MGR', 'Mark', 'Smith', 155000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  15, 'BUS', 'MGR', 'Jill', 'Jones', 175000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  16, 'OPE', 'ENG', 'Megan', 'Craig', 245000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  17, 'SUP', 'TEC', 'Matthew', 'Brant', 115000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  18, 'OPE', 'MGR', 'Tony', 'Clerke', 200000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  19, 'BUS', 'MGR', 'Tanya', 'Conway', 200000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  20, 'OPE', 'MGR', 'Terry', 'Cliff', 215000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  21, 'SAL', 'MGR', 'Steve', 'Green', 275000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  22, 'SAL', 'MGR', 'Roy', 'Red', 375000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  23, 'SAL', 'MGR', 'Sandra', 'Smith', 335000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  24, 'SAL', 'MGR', 'Gail', 'Silver', 225000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  25, 'SAL', 'MGR', 'Gerald', 'Gold', 245000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  26, 'SAL', 'MGR', 'Eileen', 'Lane', 235000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  27, 'SAL', 'MGR', 'Doreen', 'Upton', 235000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  28, 'SAL', 'MGR', 'Jack', 'Ewing', 235000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  29, 'SAL', 'MGR', 'Paul', 'Owens', 245000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  30, 'SAL', 'MGR', 'Melanie', 'York', 255000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  31, 'SAL', 'MGR', 'Tracy', 'Yellow', 225000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  32, 'SAL', 'MGR', 'Sarah', 'White', 235000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  33, 'SAL', 'MGR', 'Terry', 'Iron', 225000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  34, 'SAL', 'MGR', 'Christine', 'Brown', 247000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  35, 'SAL', 'MGR', 'John', 'Brown', 249000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  36, 'SAL', 'MGR', 'Kelvin', 'Trenton', 255000
);

INSERT INTO employees2 (
  employee_id, division_id, job_id, first_name, last_name, salary
) VALUES (
  37, 'BUS', 'WOR', 'Damon', 'Jones', 280000
);

-- commit the transaction
COMMIT;

-- insert sample data into all_sales table

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 1, 10034.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 2, 15144.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 3, 20137.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 4, 25057.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 5, 17214.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 6, 15564.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 7, 12654.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 8, 17434.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 9, 19854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 10, 21754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 11, 13029.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 1, 2003, 12, 10034.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 1, 1034.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 2, 1544.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 3, 2037.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 4, 2557.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 5, 1714.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 6, 1564.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 7, 1264.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 8, 1734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 9, 1854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 10, 2754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 11, 1329.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 2, 2003, 12, 1034.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 1, 6034.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 2, 1944.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 3, 2537.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 4, 4557.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 5, 3714.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 6, 3564.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 7, 21264.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 8, 21734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 9, 12854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 10, 32754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 11, 15329.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 3, 2003, 12, 14034.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 1, 3034.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 2, 2944.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 3, 5537.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 4, 3557.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 5, 2714.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 6, 7564.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 7, 1264.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 8, 21734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 9, 14854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 10, 22754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 11, 11329.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 4, 2003, 12, 11034.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 1, 11034.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 2, 16144.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 3, 24137.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 4, 29057.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 5, 19214.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 6, 16564.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 7, 13654.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 8, 17834.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 9, 21854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 10, 18754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 11, 16529.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 1, 2003, 12, 9434.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 1, 1234.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 2, 1044.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 3, 2537.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 4, 2657.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 5, 1314.56
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 6, 1264.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 7, 1964.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 8, 1234.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 9, 1954.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 10, 2254.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 11, 1229.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 2, 2003, 12, 1134.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 1, 6334.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 2, 1544.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 3, 2737.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 4, 4657.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 5, 3714.56
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 6, 3864.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 7, 27264.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 8, 17734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 9, 10854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 10, 15754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 11, 10329.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 3, 2003, 12, 12034.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 1, 3334.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 2, 2344.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 3, 5137.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 4, 3157.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 5, 2114.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 6, 7064.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 7, 1564.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 8, 12734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 9, 10854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 10, 20754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 11, 10329.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 4, 2003, 12, 2034.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 1, 4034.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 2, 7144.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 3, 12137.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 4, 16057.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 5, 13214.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 6, 3564.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 7, 7654.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 8, 5834.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 9, 6754.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 10, 12534.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 11, 2529.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 1, 2003, 12, 7434.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 1, 1234.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 2, 2244.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 3, 2137.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 4, 2357.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 5, 1314.56
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 6, 1364.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 7, 1364.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 8, 1334.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 9, 1354.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 10, 2354.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 11, 1329.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 2, 2003, 12, 1334.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 1, 6334.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 2, 1344.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 3, 2337.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 4, 4357.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 5, 3314.56
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 6, 3364.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 7, 23264.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 8, 13734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 9, 13854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 10, 13754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 11, 13329.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 3, 2003, 12, 13034.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 1, 3334.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 2, 2344.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 3, 5337.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 4, 3357.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 5, 2314.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 6, 7364.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 7, 1364.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 8, 13734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 9, 13854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 10, 23754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 11, 13329.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 4, 2003, 12, 2334.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 1, 7034.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 2, 17144.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 3, 22137.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 4, 24057.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 5, 25214.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 6, 14564.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 7, 17654.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 8, 15834.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 9, 15854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 10, 22754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 11, 14529.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 1, 2003, 12, 10434.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 1, 1934.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 2, 2844.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 3, 2837.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 4, 2697.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 5, 7314.56
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 6, 1864.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 7, 2364.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 8, 4334.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 9, 6654.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 10, 2254.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 11, 5429.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 2, 2003, 12, 3334.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 1, 2334.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 2, 4544.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 3, 6337.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 4, 3357.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 5, 2314.56
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 6, 1364.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 7, 5264.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 8, 1734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 9, 1854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 10, 1354.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 11, 1332.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 3, 2003, 12, 3034.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 1, 3364.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 2, 4344.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 3, 4337.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 4, 2357.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 5, 6314.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 6, 4364.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 7, 2364.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 8, 3734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 9, 3854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 10, 3754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 11, 1329.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 4, 2003, 12, 7334.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 1, 1234.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 2, 6144.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 3, 8137.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 4, 14057.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 5, 12214.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 6, 4564.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 7, 5654.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 8, 8834.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 9, 10854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 10, 12754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 11, 3529.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 1, 2003, 12, 5434.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 1, 3434.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 2, 1844.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 3, 2137.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 4, 1697.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 5, 4314.56
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 6, 3264.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 7, 5364.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 8, 3334.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 9, 2654.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 10, 454.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 11, 2429.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 2, 2003, 12, 1334.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 1, 1434.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 2, 3544.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 3, 1337.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 4, 1457.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 5, 1314.56
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 6, 4364.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 7, 1264.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 8, 2734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 9, 4354.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 10, 2354.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 11, 3432.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 3, 2003, 12, 1534.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 1, 1164.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 2, 2144.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 3, 4337.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 4, 1357.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 5, 2314.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 6, 2364.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 7, 3264.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 8, 2234.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 9, 3454.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 10, 2754.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 11, 3429.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 4, 2003, 12, 4334.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 1, 5534.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 2, 8844.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 3, 5137.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 4, 12057.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 5, 10214.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 6, 2564.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 7, 3654.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 8, 9834.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 9, 9854.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 10, 16754.27
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 11, 5529.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 1, 2003, 12, 3434.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 1, 5434.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 2, 3844.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 3, 5137.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 4, 3697.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 5, 2314.56
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 6, 5264.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 7, 3364.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 8, 4334.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 9, 4654.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 10, 3454.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 11, 4429.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 2, 2003, 12, 4334.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 1, 2434.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 2, 2544.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 3, 5337.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 4, 5457.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 5, 4314.56
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 6, 3364.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 7, 3264.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 8, 4734.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 9, 2354.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 10, 4354.34
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 11, 2432.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 3, 2003, 12, 4534.84
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 1, 3164.23
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 2, 3144.65
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 3, 6337.83
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 4, 2357.45
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 5, 4314.564
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 6, 4364.64
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 7, 2264.84
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 8, 4234.82
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 9, 2454.57
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 10, 1554.19
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 11, 2429.73
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 4, 2003, 12, 3334.85
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 1, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 2, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 3, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 4, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 5, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 6, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 7, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 8, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 9, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 10, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 11, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  21, 5, 2003, 12, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 1, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 2, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 3, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 4, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 5, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 6, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 7, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 8, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 9, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 10, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 11, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  22, 5, 2003, 12, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 1, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 2, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 3, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 4, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 5, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 6, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 7, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 8, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 9, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 10, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 11, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  23, 5, 2003, 12, NULL
);


INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 1, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 2, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 3, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 4, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 5, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 6, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 7, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 8, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 9, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 10, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 11, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  24, 5, 2003, 12, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 1, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 2, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 3, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 4, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 5, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 6, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 7, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 8, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 9, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 10, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 11, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  25, 5, 2003, 12, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 1, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 2, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 3, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 4, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 5, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 6, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 7, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 8, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 9, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 10, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 11, NULL
);

INSERT INTO all_sales (
  emp_id, prd_type_id, year, month, amount
) VALUES (
  26, 5, 2003, 12, NULL
);

-- commit the transaction
COMMIT;


-- insert sample data into reg_exps table

INSERT INTO reg_exps (
  id, text
) VALUES (
  1,
 'But, soft! What light through yonder window breaks?
It is the east, and Juliet is the sun.
Arise, fair sun, and kill the envious moon,
Who is already sick and pale with grief,
That thou her maid art far more fair than she.'
);

-- commit the transaction
COMMIT;