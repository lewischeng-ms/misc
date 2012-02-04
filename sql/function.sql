-- Example 1 --
create or replace function circle_area(p_radius in number)
return number
as
	v_pi number := 3.1415926;
	v_area number;
begin
	v_area := v_pi * power(p_radius, 2);
	return v_area;
end circle_area;