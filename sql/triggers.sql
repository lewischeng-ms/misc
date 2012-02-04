-- 语法
create [or replace] trigger <trigger_name>
{ before | after | instead of } <trigger_event>
on <table_name>
[for each row [when <trigger_condition>]]
begin
	<trigger_body>
end <trigger_name>;

-- trigger_event:
-- 如果是作用于表上：delete, insert, update，用or连接
-- 如果是作用于数据库：create, alter, drop, truncate, 用or连接

-- table_name:
-- 可以是具体的表名或database

-- trigger_condition:
-- 直接用new和old，不要在前面加冒号

-- trigger_body:
-- 可以用:new与:old分别引用新和旧的记录

select * from user_triggers where trigger_name='XXX';

alter trigger <trigger_name> { disable | enable };