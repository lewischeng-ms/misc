-- Example 1 --
create or replace procedure add_to(
	p_src_1 in int,
	p_src_2 in int,
	p_dst out int
	-- p_dst_1 in out int
) as -- is
	v_result int;
begin
	v_result := p_src_1 + p_src_2;
	p_dst := v_result;
-- exception others then
--	 rollback;
end add_to;