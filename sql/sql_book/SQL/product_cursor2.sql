-- product_cursor2.sql displays the product_id, name,
-- and price columns from the products table using a cursor
-- and a FOR loop

SET SERVEROUTPUT ON

DECLARE
  CURSOR cv_product_cursor IS
    SELECT product_id, name, price 
    FROM products
    ORDER BY product_id;
BEGIN
  FOR v_product IN cv_product_cursor LOOP
    DBMS_OUTPUT.PUT_LINE(
      'product_id = ' || v_product.product_id ||
      ', name = ' || v_product.name ||
      ', price = ' || v_product.price
    );
  END LOOP;
END;
/