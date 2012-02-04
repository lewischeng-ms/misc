create or replace function cas(offset in number default 0)
return varchar2
as
   broken number;
   pattern varchar2(26);
   result varchar2(52);
begin
   pattern := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   broken := mod(offset, 26);
   if broken < 0 then
      broken := broken + 26;
   end if;
   result := substr(pattern, broken + 1) || substr(pattern, 1, broken);
   result := result || lower(result);
   return result;
end;
/
