SET ECHO OFF
SET VERIFY OFF

SELECT product_id, product_type_id, name, price
FROM products
WHERE product_type_id = &1
AND price > &2;