-- The SQL*Plus script object_schema.sql performs the following:
--   1. Creates object_user
--   2. Creates the database object types
--   3. Populates the database tables with example data

-- This script should be run by the system user (or the DBA)
CONNECT /  AS SYSDBA;

-- drop object_user
DROP USER object_user CASCADE;

-- create object_user
CREATE USER object_user IDENTIFIED BY "123";

-- allow object_user to connect and create database objects
GRANT connect, resource TO object_user;

-- connect as object_user
CONNECT object_user/123;

-- create the object types
CREATE TYPE address_typ AS OBJECT (
  street VARCHAR2(15),
  city   VARCHAR2(15),
  state  CHAR(2),
  zip    VARCHAR2(5)
);
/

CREATE TYPE person_typ AS OBJECT (
  id         NUMBER,
  first_name VARCHAR2(10),
  last_name  VARCHAR2(10),
  dob        DATE,
  phone      VARCHAR2(12),
  address    address_typ
);
/

CREATE TYPE product_typ AS OBJECT (
  id          NUMBER,
  name        VARCHAR2(10),
  description VARCHAR2(22),
  price       NUMBER(5, 2),
  days_valid  NUMBER,

  -- declare the get_sell_by_date() member function,
  -- get_sell_by_date() returns the date by which the
  -- product must be sold
  MEMBER FUNCTION get_sell_by_date RETURN DATE
);
/

CREATE TYPE BODY product_typ AS
  -- define the get_sell_by_date() member function,
  -- get_sell_by_date() returns the date by which the
  -- product must be sold
  MEMBER FUNCTION get_sell_by_date RETURN DATE IS
    v_sell_by_date DATE;
  BEGIN
    -- calculate the sell by date by adding the days_valid attribute
    -- to the current date (SYSDATE)
    SELECT days_valid + SYSDATE
    INTO v_sell_by_date
    FROM dual;

    -- return the sell by date 
    RETURN v_sell_by_date;
  END;
END;
/


-- create the tables
CREATE TABLE products (
  product           product_typ,
  quantity_in_stock NUMBER
);

CREATE TABLE object_products OF product_typ;

CREATE TABLE object_customers OF person_typ;

CREATE TABLE purchases (
  id       NUMBER PRIMARY KEY,
  customer REF person_typ  SCOPE IS object_customers,
  product  REF product_typ SCOPE IS object_products
);

-- create the PL/SQL package
CREATE OR REPLACE PACKAGE product_package AS
  TYPE ref_cursor_typ IS REF CURSOR;
  FUNCTION get_products RETURN ref_cursor_typ;
  PROCEDURE insert_product (
    p_id          IN object_products.id%TYPE,
    p_name        IN object_products.name%TYPE,
    p_description IN object_products.description%TYPE,
    p_price       IN object_products.price%TYPE,
    p_days_valid  IN object_products.days_valid%TYPE
  );
END product_package;
/

CREATE OR REPLACE PACKAGE BODY product_package AS
  FUNCTION get_products
  RETURN ref_cursor_typ IS
    products_ref_cursor ref_cursor_typ;
  BEGIN
    -- get the REF CURSOR
    OPEN products_ref_cursor FOR
      SELECT VALUE(op)
      FROM object_products op;
    -- return the REF CURSOR
    RETURN products_ref_cursor;
  END get_products;

  PROCEDURE insert_product (
    p_id          IN object_products.id%TYPE,
    p_name        IN object_products.name%TYPE,
    p_description IN object_products.description%TYPE,
    p_price       IN object_products.price%TYPE,
    p_days_valid  IN object_products.days_valid%TYPE
  ) AS
    product product_typ :=
      product_typ(
        p_id, p_name, p_description, p_price, p_days_valid
      );
  BEGIN
    INSERT INTO object_products VALUES (product);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END insert_product;
END product_package;
/

-- insert sample data into products table

INSERT INTO products (
  product,
  quantity_in_stock
) VALUES (
  product_typ(1, 'Pasta', '20 oz bag of pasta', 3.95, 10),
  50
);

INSERT INTO products (
  product,
  quantity_in_stock
) VALUES (
  product_typ(2, 'Sardines', '12 oz box of sardines', 2.99, 5),
  25
);

-- insert sample data into object_products table

INSERT INTO object_products VALUES (
  product_typ(1, 'Pasta', '20 oz bag of pasta', 3.95, 10)
);

INSERT INTO object_products (
  id, name, description, price, days_valid
) VALUES (
  2, 'Sardines', '12 oz box of sardines', 2.99, 5
);


-- insert sample data into object_customers table

INSERT INTO object_customers VALUES (
  person_typ(1, 'John', 'Brown', '01-2ÔÂ-1955', '800-555-1211',
    address_typ('2 State Street', 'Beantown', 'MA', '12345')
  )
);

INSERT INTO object_customers (
  id, first_name, last_name, dob, phone,
  address
) VALUES (
  2, 'Cynthia', 'Green', '05-2ÔÂ-1968', '800-555-1212',
  address_typ('3 Free Street', 'Middle Town', 'CA', '12345')
);

-- insert sample data into purchases table

INSERT INTO purchases (
  id,
  customer,
  product
) VALUES (
  1,
  (SELECT REF(oc) FROM object_customers oc WHERE oc.id = 1),
  (SELECT REF(op) FROM object_products  op WHERE op.id = 1)
);

-- commit the transaction
COMMIT;