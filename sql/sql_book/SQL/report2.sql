SET ECHO OFF
SET VERIFY OFF

ACCEPT product_id_var NUMBER FORMAT 99 PROMPT 'Product id: '

SELECT product_id, name, price
FROM products
WHERE product_id = &product_id_var;

-- clean up
UNDEFINE product_id_var