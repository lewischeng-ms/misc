#include <stdio.h>

char *reverse_str(char *str) {
	if (!str) return 0; // null
	char *q = str;
	while (*q) ++q;
	if (q == str) return str; // empty
	--q;
	char *p = str;
	while (p < q) {
		char t = *p;
		*p = *q;
		*q = t;
		++p;
		--q;
	}
	return str;
}

int main() {
	char *s1 = 0;
	char s2[] = "";
	char s3[] = "abcsdfsesg";
	char s4[] = "abcsdfses";
	char s5[] = "a";
	char s6[] = "ab";
	printf("reverse s1 = %s\n", reverse_str(s1));
	printf("reverse s2 = %s\n", reverse_str(s2));
	printf("reverse s3 = %s\n", reverse_str(s3));
	printf("reverse s4 = %s\n", reverse_str(s4));
	printf("reverse s5 = %s\n", reverse_str(s5));
	printf("reverse s6 = %s\n", reverse_str(s6));
	return 0;
}