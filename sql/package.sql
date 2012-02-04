-- 创建包的specification --
create or replace package sample_package
as
	-- 相当于C里的typedef
	type t_ref_cursor is ref cursor;
	
	function get_products (
		p_product_type_id in products.product_type_id%type
	) return t_ref_cursor;
	
	procedure hello (
		p_message in varchar2
	);
end sample_package;

-- 创建包的body --
create or replace package body sample_package
as
	function get_products (
		p_product_type_id in products.product_type_id%type
	) return t_ref_cursor
	is
		products_ref_cursor t_ref_cursor;
	begin
		open products_ref_cursor for
			select product_id, name, price
			from products
			where product_type_id = p_product_type_id;
		
		return products_ref_cursor;
	end get_products;
	
	procedure hello (
		p_message in varchar2
	)
	is
		v_message varchar2(20);
	begin
		v_message := 'hello: ' || p_message;
		dbms_output.put_line(v_message);
	end;
end sample_package;

exec sample_package.hello('tom');
select sample_package.get_products(1) from dual;

-- object_name是包名
-- procedure_name是函数或过程名
select object_name, procedure_name
from user_procedures
where object_name = 'SAMPLE_PACKAGE';