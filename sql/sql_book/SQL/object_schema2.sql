-- The SQL*Plus script object_schema2.sql performs the following:
--   1. Creates object_user2
--   2. Creates the database object types
--   3. Populates the database tables with example data

-- This script should be run by the system user (or the DBA)
CONNECT / AS SYSDBA;

-- drop object_user2
DROP USER object_user2 CASCADE;

-- create object_user2
CREATE USER object_user2 IDENTIFIED BY "123";

-- allow object_user2 to connect and create database objects
GRANT connect, resource TO object_user2;

-- connect as object_user2
CONNECT object_user2/123;

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
) NOT FINAL;
/

CREATE TYPE business_person_typ UNDER person_typ (
  title   VARCHAR2(20),
  company VARCHAR2(20)
);
/

CREATE TYPE vehicle_typ AS OBJECT (
  id    NUMBER,
  make  VARCHAR2(15),
  model VARCHAR2(15)
) NOT FINAL NOT INSTANTIABLE;
/

CREATE TYPE car_typ UNDER vehicle_typ (
  convertible CHAR(1)
);
/

CREATE TYPE motorcycle_typ UNDER vehicle_typ (
  sidecar CHAR(1)
);
/

CREATE OR REPLACE TYPE person_typ2 AS OBJECT (
  id         NUMBER,
  first_name VARCHAR2(10),
  last_name  VARCHAR2(10),
  dob        DATE,
  phone      VARCHAR2(12),
  CONSTRUCTOR FUNCTION person_typ2(
    p_id         NUMBER,
    p_first_name VARCHAR2,
    p_last_name  VARCHAR2
  ) RETURN SELF AS RESULT,
  CONSTRUCTOR FUNCTION person_typ2(
    p_id         NUMBER,
    p_first_name VARCHAR2,
    p_last_name  VARCHAR2,
    p_dob        DATE,
    p_phone      VARCHAR2
  ) RETURN SELF AS RESULT
);
/

CREATE OR REPLACE TYPE BODY person_typ2 AS
  CONSTRUCTOR FUNCTION person_typ2(
    p_id         NUMBER,
    p_first_name VARCHAR2,
    p_last_name  VARCHAR2
  ) RETURN SELF AS RESULT IS
  BEGIN
    SELF.id := p_id;
    SELF.first_name := p_first_name;
    SELF.last_name := p_last_name;
    SELF.dob := SYSDATE;
    SELF.phone := '555-1212';
    RETURN;
  END;
  CONSTRUCTOR FUNCTION person_typ2(
    p_id         NUMBER,
    p_first_name VARCHAR2,
    p_last_name  VARCHAR2,
    p_dob        DATE,
    p_phone      VARCHAR2
  ) RETURN SELF AS RESULT IS
  BEGIN
    SELF.id := p_id;
    SELF.first_name := p_first_name;
    SELF.last_name := p_last_name;
    SELF.dob := p_dob;
    SELF.phone := p_phone;
    RETURN;
  END;
END;
/

-- create the tables
CREATE TABLE object_customers OF person_typ;

CREATE TABLE object_business_customers OF business_person_typ;

CREATE TABLE vehicles OF vehicle_typ;

CREATE TABLE cars OF car_typ;

CREATE TABLE motorcycles OF motorcycle_typ;

CREATE TABLE object_customers2 OF person_typ2;

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

-- insert sample data into object_business_customers table
INSERT INTO object_business_customers VALUES (
  business_person_typ(1, 'John', 'Brown', '01-2ÔÂ-1955', '800-555-1211',
    address_typ('2 State Street', 'Beantown', 'MA', '12345'),
    'Manager', 'XYZ Corp'
  )
);

-- insert sample data into cars table
INSERT INTO cars VALUES (
  car_typ(1, 'Toyota', 'MR2', 'Y')
);

-- insert sample data into motorcycles table
INSERT INTO motorcycles VALUES (
  motorcycle_typ(1, 'Harley-Davidson', 'V-Rod', 'N')
);

-- commit the transaction
COMMIT;