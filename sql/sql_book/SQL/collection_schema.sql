-- The SQL*Plus script collection_user.sql performs the following:
--   1. Creates collection_user
--   2. Creates the database object and collection type
--   3. Populates the database tables with example data

-- This script should be run by the system user (or the DBA)
CONNECT / AS SYSDBA;

-- drop collection_user
DROP USER collection_user CASCADE;

-- create collection_user
CREATE USER collection_user IDENTIFIED BY "123";

-- allow collection_user to connect and create database objects
GRANT connect, resource TO collection_user;

-- connect as collection_user
CONNECT collection_user/123;

-- create the object and collection types
CREATE TYPE address_typ AS OBJECT (
  street VARCHAR2(15),
  city   VARCHAR2(15),
  state  CHAR(2),
  zip    VARCHAR2(5)
);
/

CREATE TYPE varray_address_typ AS VARRAY(2) OF VARCHAR2(50);
/

CREATE TYPE nested_table_address_typ AS TABLE OF address_typ;
/

-- create the tables
CREATE TABLE customers_with_varray (
  id         INTEGER PRIMARY KEY,
  first_name VARCHAR2(10),
  last_name  VARCHAR2(10),
  addresses  varray_address_typ
);

CREATE TABLE customers_with_nested_table (
  id         INTEGER PRIMARY KEY,
  first_name VARCHAR2(10),
  last_name  VARCHAR2(10),
  addresses  nested_table_address_typ
)
NESTED TABLE
  addresses
STORE AS
  nested_addresses;


-- create the PL/SQL packages
CREATE OR REPLACE PACKAGE varray_package AS
  TYPE ref_cursor_typ IS REF CURSOR;
  FUNCTION get_customers RETURN ref_cursor_typ;
  PROCEDURE insert_customer (
    p_id         IN customers_with_varray.id%TYPE,
    p_first_name IN customers_with_varray.first_name%TYPE,
    p_last_name  IN customers_with_varray.last_name%TYPE,
    p_addresses  IN customers_with_varray.addresses%TYPE
  );
END varray_package;
/

CREATE OR REPLACE PACKAGE BODY varray_package AS
  FUNCTION get_customers
  RETURN ref_cursor_typ IS
    customers_ref_cursor ref_cursor_typ;
  BEGIN
    -- get the REF CURSOR
    OPEN customers_ref_cursor FOR
      SELECT *
      FROM customers_with_varray;
    -- return the REF CURSOR
    RETURN customers_ref_cursor;
  END get_customers;

  PROCEDURE insert_customer (
    p_id         IN customers_with_varray.id%TYPE,
    p_first_name IN customers_with_varray.first_name%TYPE,
    p_last_name  IN customers_with_varray.last_name%TYPE,
    p_addresses  IN customers_with_varray.addresses%TYPE
  ) IS
  BEGIN
    INSERT INTO customers_with_varray
    VALUES (p_id, p_first_name, p_last_name, p_addresses);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END insert_customer;
END varray_package;
/

CREATE OR REPLACE PACKAGE nested_table_package AS
  TYPE ref_cursor_typ IS REF CURSOR;
  FUNCTION get_customers RETURN ref_cursor_typ;
  PROCEDURE insert_customer (
    p_id         IN customers_with_nested_table.id%TYPE,
    p_first_name IN customers_with_nested_table.first_name%TYPE,
    p_last_name  IN customers_with_nested_table.last_name%TYPE,
    p_addresses  IN customers_with_nested_table.addresses%TYPE
  );
END nested_table_package;
/

CREATE OR REPLACE PACKAGE BODY nested_table_package AS
  FUNCTION get_customers
  RETURN ref_cursor_typ IS
    customers_ref_cursor ref_cursor_typ;
  BEGIN
    -- get the REF CURSOR
    OPEN customers_ref_cursor FOR
      SELECT *
      FROM customers_with_nested_table;
    -- return the REF CURSOR
    RETURN customers_ref_cursor;
  END get_customers;

  PROCEDURE insert_customer (
    p_id         IN customers_with_nested_table.id%TYPE,
    p_first_name IN customers_with_nested_table.first_name%TYPE,
    p_last_name  IN customers_with_nested_table.last_name%TYPE,
    p_addresses  IN customers_with_nested_table.addresses%TYPE
  ) IS
  BEGIN
    INSERT INTO customers_with_nested_table
    VALUES (p_id, p_first_name, p_last_name, p_addresses);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END insert_customer;
END nested_table_package;
/

CREATE OR REPLACE PACKAGE collection_method_examples AS

  FUNCTION initialize_addresses (
    id_par customers_with_nested_table.id%TYPE
  ) RETURN nested_table_address_typ;
  PROCEDURE display_addresses (
    addresses_par nested_table_address_typ
  );
  PROCEDURE delete_address (
    address_num_par INTEGER
  );
  PROCEDURE extend_addresses;
  PROCEDURE first_address;
  PROCEDURE last_address;
  PROCEDURE next_address;
  PROCEDURE prior_address;
  PROCEDURE trim_addresses;

END collection_method_examples;
/

CREATE OR REPLACE PACKAGE BODY collection_method_examples AS

  FUNCTION initialize_addresses (
    id_par customers_with_nested_table.id%TYPE
  ) RETURN nested_table_address_typ IS
    addresses_var nested_table_address_typ;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Initializing addresses');
    SELECT addresses
    INTO addresses_var
    FROM customers_with_nested_table
    WHERE id = id_par;
    DBMS_OUTPUT.PUT_LINE(
      'Number of addresses = '|| addresses_var.COUNT
    );
    RETURN addresses_var;
  END initialize_addresses;

  PROCEDURE display_addresses (
    addresses_par nested_table_address_typ
  ) IS
    count_var INTEGER;
  BEGIN
    DBMS_OUTPUT.PUT_LINE(
      'Current number of addresses = '|| addresses_par.COUNT
    );
    FOR count_var IN 1..addresses_par.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE('Address #' || count_var || ':');
      DBMS_OUTPUT.PUT(addresses_par(count_var).street || ', ');
      DBMS_OUTPUT.PUT(addresses_par(count_var).city || ', ');
      DBMS_OUTPUT.PUT(addresses_par(count_var).state || ', ');
      DBMS_OUTPUT.PUT_LINE(addresses_par(count_var).zip);
    END LOOP;
  END display_addresses;

  PROCEDURE delete_address (
    address_num_par INTEGER
  ) IS
    addresses_var nested_table_address_typ;
  BEGIN
    addresses_var := initialize_addresses(1);
    display_addresses(addresses_var);
    DBMS_OUTPUT.PUT_LINE('Deleting address #' || address_num_par);
    addresses_var.DELETE(address_num_par);
    display_addresses(addresses_var);
  END delete_address;

  PROCEDURE extend_addresses IS
    addresses_var nested_table_address_typ;
  BEGIN
    addresses_var := initialize_addresses(1);
    display_addresses(addresses_var);
    DBMS_OUTPUT.PUT_LINE('Extending addresses');
    addresses_var.EXTEND(2, 1);
    display_addresses(addresses_var);
  END extend_addresses;

  PROCEDURE first_address IS
    addresses_var nested_table_address_typ;
  BEGIN
    addresses_var := initialize_addresses(1);
    DBMS_OUTPUT.PUT_LINE('First address = ' || addresses_var.FIRST);
    DBMS_OUTPUT.PUT_LINE('Deleting address #1');
    addresses_var.DELETE(1);
    DBMS_OUTPUT.PUT_LINE('First address = ' || addresses_var.FIRST);
  END first_address;

  PROCEDURE last_address IS
    addresses_var nested_table_address_typ;
  BEGIN
    addresses_var := initialize_addresses(1);
    DBMS_OUTPUT.PUT_LINE('Last address = ' || addresses_var.LAST);
    DBMS_OUTPUT.PUT_LINE('Deleting address #2');
    addresses_var.DELETE(2);
    DBMS_OUTPUT.PUT_LINE('Last address = ' || addresses_var.LAST);
  END last_address;

  PROCEDURE next_address IS
    addresses_var nested_table_address_typ;
  BEGIN
    addresses_var := initialize_addresses(1);
    DBMS_OUTPUT.PUT_LINE(
      'addresses_var.NEXT(1) = ' || addresses_var.NEXT(1)
    );
    DBMS_OUTPUT.PUT_LINE(
      'addresses_var.NEXT(2) = ' || addresses_var.NEXT(2)
    );
  END next_address;

  PROCEDURE prior_address IS
    addresses_var nested_table_address_typ;
  BEGIN
    addresses_var := initialize_addresses(1);
    DBMS_OUTPUT.PUT_LINE(
      'addresses_var.PRIOR(2) = ' || addresses_var.PRIOR(2)
    );
    DBMS_OUTPUT.PUT_LINE(
      'addresses_var.PRIOR(1) = ' || addresses_var.PRIOR(1)
    );
  END prior_address;

  PROCEDURE trim_addresses IS
    addresses_var nested_table_address_typ;
  BEGIN
    addresses_var := initialize_addresses(1);
    display_addresses(addresses_var);
    DBMS_OUTPUT.PUT_LINE('Extending addresses');
    addresses_var.EXTEND(3, 1);
    display_addresses(addresses_var);
    DBMS_OUTPUT.PUT_LINE('Trimming 2 addresses from end');
    addresses_var.TRIM(2);
    display_addresses(addresses_var);
  END trim_addresses;

END collection_method_examples;
/

-- insert sample data into customers_with_varray table

INSERT INTO customers_with_varray VALUES (
  1, 'Steve', 'Brown',
  varray_address_typ(
    '2 State Street, Beantown, MA, 12345',
    '4 Hill Street, Lost Town, CA, 54321'
  )
);

-- insert sample data into customers_with_nested_table table

INSERT INTO customers_with_nested_table VALUES (
  1, 'Steve', 'Brown',
  nested_table_address_typ(
    address_typ('2 State Street', 'Beantown', 'MA', '12345'),
    address_typ('4 Hill Street', 'Lost Town', 'CA', '54321')
  )
);

-- commit the transaction
COMMIT;