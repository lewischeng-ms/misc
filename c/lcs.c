#include <stdio.h>

int lcs(const char * s1, int n1, const char * s2, int n2)
{
	if (n1 == 0 || n2 == 0)
		return 0;
	if (s1[n1 - 1] == s2[n2 - 1])
		return 1 + lcs(s1, n1 - 1, s2, n2 - 1);
	int l1 = lcs(s1, n1 - 1, s2, n2);
	int l2 = lcs(s1, n1, s2, n2 - 1);
	return l1 > l2 ? l1 : l2;
}

int main()
{
	printf("lcs = %d.\n", lcs("abfc", 4, "abcfbc", 6));
	return 0;
}