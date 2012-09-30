-- The SQL*Plus script oracle_10g_examples.sql performs the following:
--   Connects as store and creates items for 10g examples
--   featured in Chapter 1

CONNECT store/store_password;

-- BINARY_FLOAT and BINARY_DOUBLE example
CREATE TABLE binary_test (
  bin_float BINARY_FLOAT,
  bin_double BINARY_DOUBLE
);

INSERT INTO binary_test (
  bin_float, bin_double
) VALUES (
  39.5f, 15.7d
);

INSERT INTO binary_test (
  bin_float, bin_double
) VALUES (
  BINARY_FLOAT_INFINITY, BINARY_DOUBLE_INFINITY
);

-- commit the transaction
COMMIT;