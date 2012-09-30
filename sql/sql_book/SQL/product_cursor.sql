-- product_cursor.sql displays the product_id, name,
-- and price columns from the products table using a cursor

SET SERVEROUTPUT ON

DECLARE

  -- step 1: declare the variables
  v_product_id products.product_id%TYPE;
  v_name       products.name%TYPE;
  v_price      products.price%TYPE;

  -- step 2: declare the cursor
  CURSOR cv_product_cursor IS
    SELECT product_id, name, price 
    FROM products
    ORDER BY product_id;

BEGIN

  -- step 3: open the cursor
  OPEN cv_product_cursor;

  LOOP

    -- step 4: fetch the rows from the cursor
    FETCH cv_product_cursor
    INTO v_product_id, v_name, v_price;

    -- exit the loop when there are no more rows, as indicated by
    -- the Boolean variable cv_product_cursor%NOTFOUND (= true when
    -- there are no more rows)
    EXIT WHEN cv_product_cursor%NOTFOUND;

    -- use DBMS_OUTPUT.PUT_LINE() to display the variables
    DBMS_OUTPUT.PUT_LINE(
      'v_product_id = ' || v_product_id || ', v_name = ' || v_name ||
      ', v_price = ' || v_price
    );

  END LOOP;

  -- step 5: close the cursor
  CLOSE cv_product_cursor;

END;
/
