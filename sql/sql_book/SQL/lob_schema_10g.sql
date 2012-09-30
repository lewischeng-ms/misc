-- The SQL*Plus script lob_schema_10g.sql performs the following:
--   Connects as lob_user and creates items for 10g examples
--   featured in Chapter 14

CONNECT lob_user/lob_password

-- implicit conversion between CLOB and NCLOB object example
CREATE TABLE nclob_content (
  id INTEGER PRIMARY KEY,
  nclob_column NCLOB
);

CREATE OR REPLACE PROCEDURE nclob_example
AS
  clob_var CLOB := 'It is the east and Juliet is the sun';
  nclob_var NCLOB;
BEGIN
  -- insert clob_var into nclob_column 
  INSERT INTO nclob_content (
    id, nclob_column
  ) VALUES (
    1, clob_var
  );

  -- select nclob_column into clob_var 
  SELECT nclob_column
  INTO clob_var
  FROM nclob_content
  WHERE id = 1;

  -- display the CLOB
  DBMS_OUTPUT.PUT_LINE('clob_var = ' || clob_var);
END nclob_example;
/

-- use :new attribute when using LOBs in a BEFORE UPDATE trigger
CREATE OR REPLACE TRIGGER before_clob_content_update
BEFORE UPDATE
ON clob_content
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('clob_content changed');
  DBMS_OUTPUT.PUT_LINE(
    'Length = ' || DBMS_LOB.GETLENGTH(:new.clob_column)
  );
END before_clob_content_update;
/

-- commit the transaction
COMMIT;