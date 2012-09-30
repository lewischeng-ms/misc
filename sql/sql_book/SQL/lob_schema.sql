-- The SQL*Plus script lob_schema.sql performs the following:
--   1. Creates lob_user
--   2. Creates the database objects
--   3. Populates the database tables with example data

-- This script should be run by the system user (or the DBA)
CONNECT / as sysdba;

-- drop lob_user
DROP USER lob_user CASCADE;

-- create lob_user
CREATE USER lob_user IDENTIFIED BY "123";

-- allow the user to connect, create database objects and
-- create directory objects (for the BFILEs)
GRANT connect, resource, create any directory TO lob_user;

-- connect as lob_user
CONNECT lob_user/123;

-- create the tables
CREATE TABLE clob_content (
  id          INTEGER PRIMARY KEY,
  clob_column CLOB NOT NULL
);

CREATE TABLE blob_content (
  id          INTEGER PRIMARY KEY,
  blob_column BLOB NOT NULL
);

CREATE TABLE bfile_content (
  id           INTEGER PRIMARY KEY,
  bfile_column BFILE NOT NULL
);

CREATE TABLE long_content (
  id          INTEGER PRIMARY KEY,
  long_column LONG NOT NULL
);

CREATE TABLE long_raw_content (
  id              INTEGER PRIMARY KEY,
  long_raw_column LONG RAW NOT NULL
);

-- create the BFILE directory
CREATE OR REPLACE DIRECTORY SAMPLE_FILES_DIR AS 'C:\sample_files';

-- create the PL/SQL procedures and methods
CREATE OR REPLACE PROCEDURE initialize_clob(
  clob_par IN OUT CLOB,
  id_par IN INTEGER
) IS
BEGIN
  SELECT clob_column
  INTO clob_par
  FROM clob_content
  WHERE id = id_par;
END initialize_clob;
/

CREATE OR REPLACE PROCEDURE initialize_blob(
  blob_par IN OUT BLOB,
  id_par IN INTEGER
) IS
BEGIN
  SELECT blob_column
  INTO blob_par
  FROM blob_content
  WHERE id = id_par;
END initialize_blob;
/

CREATE OR REPLACE PROCEDURE read_clob_example(
  id_par IN INTEGER
) IS
  clob_var CLOB;
  char_buffer_var VARCHAR2(50);
  offset_var INTEGER := 1;
  amount_var INTEGER := 50;
BEGIN
  initialize_clob(clob_var, id_par);
  DBMS_LOB.READ(clob_var, amount_var, offset_var, char_buffer_var);
  DBMS_OUTPUT.PUT_LINE('char_buffer_var = ' || char_buffer_var);
  DBMS_OUTPUT.PUT_LINE('amount_var = ' || amount_var);
END read_clob_example;
/

CREATE OR REPLACE PROCEDURE read_blob_example(
  id_par IN INTEGER
) IS
  blob_var BLOB;
  binary_buffer_var RAW(25);
  offset_var INTEGER := 1;
  amount_var INTEGER := 25;
BEGIN
  initialize_blob(blob_var, id_par);
  DBMS_LOB.READ(blob_var, amount_var, offset_var, binary_buffer_var);
  DBMS_OUTPUT.PUT_LINE('binary_buffer_var = ' || binary_buffer_var);
  DBMS_OUTPUT.PUT_LINE('amount_var = ' || amount_var);
END read_blob_example;
/

CREATE OR REPLACE PROCEDURE write_example(
  id_par IN INTEGER
) IS
  clob_var CLOB;
  char_buffer_var VARCHAR2(10) := 'pretty';
  offset_var INTEGER := 7;
  amount_var INTEGER := 6;
BEGIN
  SELECT clob_column
  INTO clob_var
  FROM clob_content
  WHERE id = id_par
  FOR UPDATE;

  read_clob_example(1);
  DBMS_LOB.WRITE(clob_var, amount_var, offset_var, char_buffer_var);
  read_clob_example(1);

  ROLLBACK;
END write_example;
/

CREATE OR REPLACE PROCEDURE append_example IS
  src_clob_var CLOB;
  dest_clob_var CLOB;
BEGIN
  SELECT clob_column
  INTO src_clob_var
  FROM clob_content
  WHERE id = 2;

  SELECT clob_column
  INTO dest_clob_var
  FROM clob_content
  WHERE id = 1
  FOR UPDATE;

  read_clob_example(1);
  DBMS_LOB.APPEND(dest_clob_var, src_clob_var);
  read_clob_example(1);

  ROLLBACK;
END append_example;
/

CREATE OR REPLACE PROCEDURE compare_example IS
  clob_var1 CLOB;
  clob_var2 CLOB;
  return_var INTEGER;
BEGIN
  SELECT clob_column
  INTO clob_var1
  FROM clob_content
  WHERE id = 1;

  SELECT clob_column
  INTO clob_var2
  FROM clob_content
  WHERE id = 2;

  DBMS_OUTPUT.PUT_LINE('Comparing clob_var1 with clob_var2');
  return_var := DBMS_LOB.COMPARE(clob_var1, clob_var2);
  DBMS_OUTPUT.PUT_LINE('return_var = ' || return_var);

  DBMS_OUTPUT.PUT_LINE('Comparing clob_var1 with clob_var1');
  return_var := DBMS_LOB.COMPARE(clob_var1, clob_var1);
  DBMS_OUTPUT.PUT_LINE('return_var = ' || return_var);
END compare_example;
/

CREATE OR REPLACE PROCEDURE copy_example IS
  src_clob_var CLOB;
  dest_clob_var CLOB;
  src_offset_var INTEGER := 1;
  dest_offset_var INTEGER := 7;
  amount_var INTEGER := 5;
BEGIN
  SELECT clob_column
  INTO src_clob_var
  FROM clob_content
  WHERE id = 2;

  SELECT clob_column
  INTO dest_clob_var
  FROM clob_content
  WHERE id = 1
  FOR UPDATE;

  read_clob_example(1);
  DBMS_LOB.COPY(
    dest_clob_var, src_clob_var, amount_var,
    dest_offset_var, src_offset_var
  );
  read_clob_example(1);

  ROLLBACK;
END copy_example;
/

CREATE OR REPLACE PROCEDURE temporary_lob_example IS
  clob_var CLOB;
  amount_var INTEGER := 19;
  offset_var INTEGER := 1;
  char_buffer_var VARCHAR2(19) := 'Juliet is the sun';
BEGIN
  DBMS_LOB.CREATETEMPORARY(clob_var, TRUE);
  DBMS_LOB.WRITE(clob_var, amount_var, offset_var, char_buffer_var);

  IF (DBMS_LOB.ISTEMPORARY(clob_var) = 1) THEN
    DBMS_OUTPUT.PUT_LINE('clob_var is temporary');
  END IF;

  DBMS_LOB.READ(
    clob_var, amount_var, offset_var, char_buffer_var
  );
  DBMS_OUTPUT.PUT_LINE('char_buffer_var = ' || char_buffer_var);

  DBMS_LOB.FREETEMPORARY(clob_var);
END temporary_lob_example;
/

CREATE OR REPLACE PROCEDURE erase_example IS
  clob_var CLOB;
  offset_var INTEGER := 2;
  amount_var INTEGER := 5;
BEGIN
  SELECT clob_column
  INTO clob_var
  FROM clob_content
  WHERE id = 1
  FOR UPDATE;

  read_clob_example(1);
  DBMS_LOB.ERASE(clob_var, amount_var, offset_var);
  read_clob_example(1);

  ROLLBACK;
END erase_example;
/

CREATE OR REPLACE PROCEDURE file_example IS
  src_bfile_var BFILE;
  dir_alias_var VARCHAR2(50);
  filename_var VARCHAR2(50);
  chunk_size_var INTEGER;
  length_var INTEGER;
  chars_read_var INTEGER;
  dest_clob_var CLOB;
  amount_var INTEGER := 20;
  dest_offset_var INTEGER := 1;
  src_offset_var INTEGER := 1;
  char_buffer_var VARCHAR2(20);
BEGIN
  SELECT bfile_column
  INTO src_bfile_var
  FROM bfile_content
  WHERE id = 1;

  DBMS_LOB.CREATETEMPORARY(dest_clob_var, TRUE);

  IF (DBMS_LOB.FILEEXISTS(src_bfile_var) = 1) THEN
    IF (DBMS_LOB.FILEISOPEN(src_bfile_var) = 0) THEN
      DBMS_LOB.FILEOPEN(src_bfile_var);
      DBMS_LOB.FILEGETNAME(
        src_bfile_var, dir_alias_var, filename_var
      );
      DBMS_OUTPUT.PUT_LINE(
        'Directory alias = ' || dir_alias_var
      );
      DBMS_OUTPUT.PUT_LINE('Filename = ' || filename_var);

      chunk_size_var := DBMS_LOB.GETCHUNKSIZE(dest_clob_var);
      DBMS_OUTPUT.PUT_LINE('Chunk size = ' || chunk_size_var);

      length_var := DBMS_LOB.GETLENGTH(src_bfile_var);
      DBMS_OUTPUT.PUT_LINE('Length = ' || length_var);

      chars_read_var := 0;
      WHILE (chars_read_var < length_var) LOOP
        IF (length_var - chars_read_var < amount_var) THEN
          amount_var := length_var - chars_read_var;
        END IF;
        DBMS_LOB.LOADFROMFILE(
          dest_clob_var, src_bfile_var,
          amount_var, dest_offset_var,
          src_offset_var + chars_read_var
        );
        DBMS_LOB.READ(
          dest_clob_var, amount_var, src_offset_var, char_buffer_var
        );
        DBMS_OUTPUT.PUT_LINE(
          'char_buffer_var = ' || char_buffer_var
        );
        chars_read_var := chars_read_var + amount_var;
      END LOOP;
    END IF;
  END IF;
  DBMS_LOB.FILECLOSE(src_bfile_var);
  DBMS_LOB.FREETEMPORARY(dest_clob_var);
END file_example;
/

CREATE OR REPLACE PROCEDURE instr_example IS
  clob_var CLOB;
  char_buffer_var VARCHAR2(50) :=
    'It is the east and Juliet is the sun';
  pattern_var VARCHAR2(5);
  offset_var INTEGER := 1;
  amount_var INTEGER := 38;
  occurrence_var INTEGER;
  return_var INTEGER;
BEGIN
  DBMS_LOB.CREATETEMPORARY(clob_var, TRUE);
  DBMS_LOB.WRITE(clob_var, amount_var, offset_var, char_buffer_var);

  DBMS_LOB.READ(
    clob_var, amount_var, offset_var, char_buffer_var
  );
  DBMS_OUTPUT.PUT_LINE('char_buffer_var = ' || char_buffer_var);

  DBMS_OUTPUT.PUT_LINE('Searching second ''is''');
  pattern_var := 'is';
  occurrence_var := 2;
  return_var := DBMS_LOB.INSTR(
    clob_var, pattern_var, offset_var, occurrence_var
  );
  DBMS_OUTPUT.PUT_LINE('return_var = ' || return_var);

  DBMS_OUTPUT.PUT_LINE('Searching for ''Moon''');
  pattern_var := 'Moon';
  occurrence_var := 1;
  return_var := DBMS_LOB.INSTR(
    clob_var, pattern_var, offset_var, occurrence_var
  );
  DBMS_OUTPUT.PUT_LINE('return_var = ' || return_var);

  DBMS_LOB.FREETEMPORARY(clob_var);
END instr_example;
/

-- insert sample data into tables
INSERT INTO clob_content (
  id, clob_column
) VALUES (
  1, EMPTY_CLOB()
);

INSERT INTO clob_content (
  id, clob_column
) VALUES (
  2, EMPTY_CLOB()
);

UPDATE clob_content
SET clob_column = 'Creeps in this petty pace'
WHERE id = 1;

UPDATE clob_content
SET clob_column = ' from day to day'
WHERE id = 2;

INSERT INTO blob_content (
  id, blob_column
) VALUES (
  1, EMPTY_BLOB()
);

UPDATE blob_content
SET blob_column = '100111010101011111'
WHERE id = 1;

INSERT INTO bfile_content (
  id,
  bfile_column
) VALUES (
  1,
  BFILENAME('SAMPLE_FILES_DIR', 'textContent.txt')
);

INSERT INTO bfile_content (
  id,
  bfile_column
) VALUES (
  2,
  BFILENAME('SAMPLE_FILES_DIR', 'binaryContent.doc')
);

INSERT INTO long_content (
  id,
  long_column
) VALUES (
  1,
  'Creeps in this petty pace'
);

INSERT INTO long_content (
  id,
  long_column
) VALUES (
  2,
  ' from day to day'
);

INSERT INTO long_raw_content (
  id,
  long_raw_column
) VALUES (
  1,
  '100111010101011111'
);

-- commit the transaction
COMMIT;