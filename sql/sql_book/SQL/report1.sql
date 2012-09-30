-- suppress display of the statements and verification messages
SET ECHO OFF
SET VERIFY OFF

SELECT product_id, name, price
FROM products
WHERE product_id = &product_id_var;