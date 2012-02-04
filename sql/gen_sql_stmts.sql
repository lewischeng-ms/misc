-- 显示scott用户的所有表
-- dba_all_tables显示所有object tables和relational tables
declare
	cursor cur is
		select table_name
		from dba_all_tables
		where owner = 'SCOTT';
	vtable varchar2(30);
	vsql varchar2(30);
begin
	for rec in cur loop
		vtable := rec.table_name;
		vsql := 'select * from scott.' || vtable;
		execute immediate vsql;
		--dbms_output.put_line(vsql);
	end loop;
end;