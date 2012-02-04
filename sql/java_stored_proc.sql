create or replace and compile java source named "MyClass" as
-- import java.xxx;
public class MyClass {
	public static String concat(String a, String b) {
		return a + b;
	}
}
/

create or replace function java_concat(a in varchar2, b in varchar2)
return varchar2
as
language java name 'MyClass.concat(java.lang.String, java.lang.String) return java.lang.String';
/