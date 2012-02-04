-- Example 1 --
declare
	width int;
	height int:= 2;
	area int;
begin
	area := 6;
	width := area / height;
	dbms_output.put_line('width  = ' || width);
exception
	when zero_divide then
		dbms_output.put_line('Division by zero');
end;

-- Example 2 --
declare
	product_price products.price%type;
begin
	product_price := 3.146;
	dbms_output.put_line(product_price);
end;

-- Example 3 --
declare
	num int := 2;
	message varchar2(10);
begin
	if num = 1 then
		message := 'One';
	elsif num = 2 then
		message := 'Two';
	else
		message := 'Unknown';
	end if;
	dbms_output.put_line(message);
end;

-- Example 4 --
declare
	num int := 0;
begin
	loop
		num := num + 1;
		exit when num = 10;
	end loop;
	
	while num > 0 loop
		num := num - 1;
	end loop;
	
	for num in reverse 1..10 loop
		dbms_output.put(num || ' ');
	end loop;
	dbms_output.put_line('');
	
	for num in 1..10 loop
		dbms_output.put(num || ' ');
	end loop;
	dbms_output.put_line('');
end;

-- Example 5 --
declare
  v_product_id products.product_id%type;
  v_name       products.name%type;
  v_price      products.price%type;
  cursor cv_product_cursor is
    select product_id, name, price 
    from products
    order by product_id;
begin
  open cv_product_cursor;
  loop
    fetch cv_product_cursor
	into v_product_id, v_name, v_price;
    exit when cv_product_cursor%notfound;
    dbms_output.put_line(
      'v_product_id = ' || v_product_id || ', v_name = ' || v_name ||
      ', v_price = ' || v_price
    );
  end loop;
  close cv_product_cursor;
end;

-- Example 6 --
declare
  cursor cv_product_cursor is
    select product_id, name, price 
    from products
    order by product_id;
begin
  for v_product in cv_product_cursor loop
    dbms_output.put_line(
      'product_id = ' || v_product.product_id ||
      ', name = ' || v_product.name ||
      ', price = ' || v_product.price
    );
  end loop;
end;