create table a (
	id int,
	name varchar2(10),
	val int
);

insert into a values (1, 'aaa', 30);
insert into a values (2, 'aaa', 40);
insert into a values (3, 'aaa', 60);
insert into a values (4, 'bbb', 40);
insert into a values (5, 'bbb', 60);
insert into a values (6, 'bbb', 80);

select * from a;

select name,
		sum(decode(tmp.rn, 1, val)) val1,
		sum(decode(tmp.rn, 2, val)) val2,
		sum(decode(tmp.rn, 3, val)) val3
from (select a.*, row_number() over (partition by name order by val) rn from a) tmp
group by name;

drop table a purge;