-- emp表中的每条记录都有50%的概率被选为样本。
select * from scott.emp sample(50);

-- 随机排序后取出前7条记录。
select *
from (select *
	  from scott.emp
	  order by dbms_random.value(0, 1000))
where rownum < 8;