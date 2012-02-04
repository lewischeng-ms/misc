declare
-- 注意此处不能写成varchar2(N)！
	cursor cur(x varchar2) is
		select table_name
		from dba_tables
		where owner = x;
begin
	for item in cur('SCOTT') loop
		dbms_output.put_line(item.table_name);
	end loop;
end;

begin
	for item in (select table_name from dba_tables where owner = 'SCOTT') loop
		dbms_output.put_line(item.table_name);
	end loop;
end;