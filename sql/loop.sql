declare
	str varchar2(30) := 'aaa|bbb|ccc|ddd|';
	word varchar2(30);
	word_end number(10);
begin
	word_end := instr(str, '|');
	while word_end > 0 loop
		word := substr(str, 0, word_end - 1);
		str := substr(str, word_end + 1);
		word_end := instr(str, '|');
		dbms_output.put_line(word);
	end loop;
end;