-- 捕获发出的dml语句的方法:
create table mon_sql(
	username varchar2(30),
	client_ip varchar2(100),
	sql_text varchar2(4000),
	table_name varchar2(30),
	owner varchar2(30)
);

create or replace trigger tri_capt_dml_sql
before delete or insert or update on emp_temp
declare
	n number; 
	stmt varchar2(4000); 
	sql_text ora_name_list_t; 
begin 
	n := ora_sql_txt(sql_text);
	for i in 1..n loop
		stmt := stmt || sql_text(i);
	end loop;

	insert into mon_sql(username, client_ip, sql_text, table_name, owner)
	values(user,sys_context('userenv','ip_address'),stmt,'t1','rainy');
end;
/

-- 禁止ddl操作
create or replace trigger ddl_deny
before create or alter or drop or truncate on database
declare
	v_errmsg varchar2(100):= 'you have no permission to this operation';
begin
	if ora_sysevent = 'create' then
		raise_application_error(-20001, ora_dict_obj_owner || '.' || ora_dict_obj_name || ' ' || v_errmsg);
	elsif ora_sysevent = 'alter' then
		raise_application_error(-20001, ora_dict_obj_owner || '.' || ora_dict_obj_name || ' ' || v_errmsg);
	elsif ora_sysevent = 'drop' then
		raise_application_error(-20001, ora_dict_obj_owner || '.' || ora_dict_obj_name || ' ' || v_errmsg);
	elsif ora_sysevent = 'truncate' then
		raise_application_error(-20001, ora_dict_obj_owner || '.' || ora_dict_obj_name || ' ' || v_errmsg);
	end if;

	exception
		when no_data_found then null;
end;
/

-- 审计ddl操作
create table event_table (text varchar(200));

create or replace trigger bef_alter 
before create or alter or drop or truncate on database
declare
	sql_text ora_name_list_t;
	stmt varchar2(2000);
	n number;
begin
	insert into event_table values ('changed object is ' || ora_dict_obj_name);
	n := ora_sql_txt(sql_text);
	for i in 1..n loop
		stmt := stmt || sql_text(i);
	end loop;
	
	insert into event_table values ('text of triggering statement: ' || stmt);
end;
/