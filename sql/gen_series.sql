-- 生成1 3 5 7 9
select 2 * rownum - 1 from dual connect by rownum < 10;

-- 生成的树是链：1->2->...->9
select level, rownum from dual connect by rownum < 10;

-- rownum原理：每在结果集中添加一条记录，就把rownum+1。
-- 所以rownum只能作小于比较，不能大于或等于，因为不可能
-- 在不生成位于某一条记录之前的所有记录时，产生该记录。
-- 即rownum不可能直接跳跃到某个数，而只能逐步递增至该值。

-- start with如果省略，默认以每条记录为根构建森林。
-- 执行计划中：connect by without filtering神马情况。。。