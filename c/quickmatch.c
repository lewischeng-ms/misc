#include <stdio.h>

int match(const char *pattern, const char *str)
{
	switch (*pattern)
	{
	case '\0':
		return !*str;
	case '*':
		return match(pattern + 1, str) || *str && match(pattern, str + 1);
	case '?':
		return *str && match(pattern + 1, str + 1);
	default:
		return *pattern == *str && match(pattern + 1, str + 1);
	}
}

int main(int argc, char *argv[])
{
	printf("%d\n", match("a*b.c?p", "aplomb.cpp"));
	return 0;
}