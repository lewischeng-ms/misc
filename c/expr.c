#include <stdio.h>
#include <ctype.h>

int expr();
int term();
int factor();

char * exp = "3*6+8/(4-1)-11*3/2";
char * p;

int main()
{
	p = exp;
	int result = expr();
	printf("%s = %d\n", exp, result);
	return 0;
}

int expr()
{
	int result = term();
	while (*p == '+' || *p == '-')
	{
		char op = *p++;
		int opr = term();
		if (op == '+')
			result += opr;
		else
			result -= opr;
	}
	return result;
}

int term()
{
	int result = factor();
	while (*p == '*' || *p == '/')
	{
		char op = *p++;
		int opr = factor();
		if (op == '*')
			result *= opr;
		else
			result /= opr;
	}
	return result;
}

int factor()
{
	int result = 0;
	if (*p == '(')
	{
		++p; // Match '('
		result = expr();
		++p; // Match ')'
	}
	else
	{
		while (isdigit(*p))
		{
			result *= 10;
			result += (*p++) - '0';
		}
	}
	return result;
}
