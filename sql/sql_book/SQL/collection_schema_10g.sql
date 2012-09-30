-- The SQL*Plus script collection_schema_10g.sql performs the following:
--   Connects as collection_user and creates packages for 10g examples
--   featured in Chapter 13

CONNECT collection_user/123;

-- associative array example
CREATE OR REPLACE PROCEDURE customers_associative_array AS
  TYPE assoc_array_typ IS TABLE OF NUMBER INDEX BY VARCHAR2(15);
  customer_array assoc_array_typ;
BEGIN
  customer_array('Jason') := 32;
  customer_array('Steve') := 28;
  customer_array('Fred') := 43;
  customer_array('Cynthia') := 27;

  DBMS_OUTPUT.PUT_LINE(
    'customer_array[''Jason''] = ' || customer_array('Jason')
  );
  DBMS_OUTPUT.PUT_LINE(
    'customer_array[''Steve''] = ' || customer_array('Steve')
  );
  DBMS_OUTPUT.PUT_LINE(
    'customer_array[''Fred''] = ' || customer_array('Fred')
  );
  DBMS_OUTPUT.PUT_LINE(
    'customer_array[''Cynthia''] = ' || customer_array('Cynthia')
  );
END customers_associative_array;
/

-- varray in temporary table example
CREATE GLOBAL TEMPORARY TABLE cust_with_varray_temp_table (
  id         INTEGER PRIMARY KEY,
  first_name VARCHAR2(10),
  last_name  VARCHAR2(10),
  addresses  varray_address_typ
);

-- different tablespace for a nested table's storage table example
-- (assumes you have a tablespace named users, so you'll need to edit
-- the TABLESPACE clause and uncomment the example)
/*
CREATE TABLE cust_with_nested_table (
  id         INTEGER PRIMARY KEY,
  first_name VARCHAR2(10),
  last_name  VARCHAR2(10),
  addresses  nested_table_address_typ
)
NESTED TABLE
  addresses
STORE AS
  nested_addresses2 TABLESPACE users;
*/

-- equal/not equal example
CREATE OR REPLACE PROCEDURE equal_example AS
  TYPE nested_table_typ IS TABLE OF VARCHAR2(10);
  customer_nested_table1 nested_table_typ;
  customer_nested_table2 nested_table_typ;
  customer_nested_table3 nested_table_typ;
  result BOOLEAN;
BEGIN
  customer_nested_table1 :=
    nested_table_typ('Fred', 'George', 'Susan');
  customer_nested_table2 :=
    nested_table_typ('Fred', 'George', 'Susan');
  customer_nested_table3 :=
    nested_table_typ('John', 'George', 'Susan');

  result := customer_nested_table1 = customer_nested_table2;
  IF result THEN
    DBMS_OUTPUT.PUT_LINE(
      'customer_nested_table1 equal to customer_nested_table2'
    );
  END IF;

  result := customer_nested_table1 <> customer_nested_table3;
  IF result THEN
    DBMS_OUTPUT.PUT_LINE(
      'customer_nested_table1 not equal to customer_nested_table3'
    );
  END IF;
END equal_example;
/

-- IN/NOT IN example
CREATE OR REPLACE PROCEDURE in_example AS
  TYPE nested_table_typ IS TABLE OF VARCHAR2(10);
  customer_nested_table1 nested_table_typ;
  customer_nested_table2 nested_table_typ;
  customer_nested_table3 nested_table_typ;
  result BOOLEAN;
BEGIN
  customer_nested_table1 :=
    nested_table_typ('Fred', 'George', 'Susan');
  customer_nested_table2 :=
    nested_table_typ('John', 'George', 'Susan');
  customer_nested_table3 :=
    nested_table_typ('Fred', 'George', 'Susan');

  result := customer_nested_table3 IN (customer_nested_table1);
  IF result THEN
    DBMS_OUTPUT.PUT_LINE(
      'customer_nested_table3 in customer_nested_table1'
    );
  END IF;

  result := customer_nested_table3 NOT IN (customer_nested_table2);
  IF result THEN
    DBMS_OUTPUT.PUT_LINE(
      'customer_nested_table3 not in customer_nested_table2'
    );
  END IF;
END in_example;
/

-- SUBMULTISET example
CREATE OR REPLACE PROCEDURE submultiset_example AS
  TYPE nested_table_typ IS TABLE OF VARCHAR2(10);
  customer_nested_table1 nested_table_typ;
  customer_nested_table2 nested_table_typ;
  customer_nested_table3 nested_table_typ;
  result BOOLEAN;
BEGIN
  customer_nested_table1 :=
    nested_table_typ('Fred', 'George', 'Susan');
  customer_nested_table2 :=
    nested_table_typ('George', 'Fred', 'Susan');

  result :=
    customer_nested_table1 SUBMULTISET OF customer_nested_table2;
  IF result THEN
    DBMS_OUTPUT.PUT_LINE(
      'customer_nested_table1 subset of customer_nested_table2'
    );
  END IF;
END submultiset_example;
/

-- MULTISET example
CREATE OR REPLACE PROCEDURE multiset_example AS
  TYPE nested_table_typ IS TABLE OF VARCHAR2(10);
  customer_nested_table1 nested_table_typ;
  customer_nested_table2 nested_table_typ;
  customer_nested_table3 nested_table_typ;
  count_var INTEGER;
BEGIN
  customer_nested_table1 :=
    nested_table_typ('Fred', 'George', 'Susan');
  customer_nested_table2 :=
    nested_table_typ('George', 'Steve', 'Rob');

  customer_nested_table3 :=
    customer_nested_table1 MULTISET UNION customer_nested_table2;
  DBMS_OUTPUT.PUT('UNION: ');
  FOR count_var IN 1..customer_nested_table3.COUNT LOOP
    DBMS_OUTPUT.PUT(customer_nested_table3(count_var) || ' ');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(' ');

  customer_nested_table3 :=
    customer_nested_table1 MULTISET UNION DISTINCT customer_nested_table2;
  DBMS_OUTPUT.PUT('UNION DISTINCT: ');
  FOR count_var IN 1..customer_nested_table3.COUNT LOOP
    DBMS_OUTPUT.PUT(customer_nested_table3(count_var) || ' ');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(' ');

  customer_nested_table3 :=
    customer_nested_table1 MULTISET INTERSECT customer_nested_table2;
  DBMS_OUTPUT.PUT('INTERSECT: ');
  FOR count_var IN 1..customer_nested_table3.COUNT LOOP
    DBMS_OUTPUT.PUT(customer_nested_table3(count_var) || ' ');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(' ');

  customer_nested_table3 :=
    customer_nested_table1 MULTISET EXCEPT customer_nested_table2;
  DBMS_OUTPUT.PUT_LINE('EXCEPT: ');
  FOR count_var IN 1..customer_nested_table3.COUNT LOOP
    DBMS_OUTPUT.PUT(customer_nested_table3(count_var) || ' ');
  END LOOP;
END multiset_example;
/

-- CARDINALITY example
CREATE OR REPLACE PROCEDURE cardinality_example AS
  TYPE nested_table_typ IS TABLE OF VARCHAR2(10);
  customer_nested_table1 nested_table_typ;
  cardinality_var INTEGER;
BEGIN
  customer_nested_table1 :=
    nested_table_typ('Fred', 'George', 'Susan');
  cardinality_var := CARDINALITY(customer_nested_table1);
  DBMS_OUTPUT.PUT_LINE('cardinality_var = ' || cardinality_var);
END cardinality_example;
/

-- MEMBER OF example
CREATE OR REPLACE PROCEDURE member_of_example AS
  TYPE nested_table_typ IS TABLE OF VARCHAR2(10);
  customer_nested_table1 nested_table_typ;
  result BOOLEAN;
BEGIN
  customer_nested_table1 :=
    nested_table_typ('Fred', 'George', 'Susan');
  result := 'George' MEMBER OF customer_nested_table1;
  IF result THEN
    DBMS_OUTPUT.PUT_LINE('''George'' is a member');
  END IF;
END member_of_example;
/

-- SET example
CREATE OR REPLACE PROCEDURE set_example AS
  TYPE nested_table_typ IS TABLE OF VARCHAR2(10);
  customer_nested_table1 nested_table_typ;
  customer_nested_table2 nested_table_typ;
  count_var INTEGER;
BEGIN
  customer_nested_table1 :=
    nested_table_typ('Fred', 'George', 'Susan', 'George');
  customer_nested_table2 := SET(customer_nested_table1);
  DBMS_OUTPUT.PUT('customer_nested_table2: ');
  FOR count_var IN 1..customer_nested_table2.COUNT LOOP
    DBMS_OUTPUT.PUT(customer_nested_table2(count_var) || ' ');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(' ');
END set_example;
/

-- IS A SET example
CREATE OR REPLACE PROCEDURE is_a_set_example AS
  TYPE nested_table_typ IS TABLE OF VARCHAR2(10);
  customer_nested_table1 nested_table_typ;
  result BOOLEAN;
BEGIN
  customer_nested_table1 :=
    nested_table_typ('Fred', 'George', 'Susan', 'George');
  result := customer_nested_table1 IS A SET;
  IF result THEN
    DBMS_OUTPUT.PUT_LINE('Elements are all unique');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Elements contain duplicates');
  END IF;
END is_a_set_example;
/

-- IS EMPTY example
CREATE OR REPLACE PROCEDURE is_empty_example AS
  TYPE nested_table_typ IS TABLE OF VARCHAR2(10);
  customer_nested_table1 nested_table_typ;
  result BOOLEAN;
BEGIN
  customer_nested_table1 :=
    nested_table_typ('Fred', 'George', 'Susan');
  result := customer_nested_table1 IS EMPTY;
  IF result THEN
    DBMS_OUTPUT.PUT_LINE('Nested table is empty');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Nested table contains elements');
  END IF;
END is_empty_example;
/

-- commit the transaction
COMMIT;