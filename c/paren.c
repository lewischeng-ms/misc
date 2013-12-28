#include <stdio.h>
#include <ctype.h>

#define MAX_STACK_SIZE 500

void paren(char *str) {
	char stack[MAX_STACK_SIZE];
	int top = -1;
	char *p = str;
	while (*p) {
		if (isdigit(*p)) {
			putchar(*p);
		} else if (*p == '(') {
			++top;
			if (top >= MAX_STACK_SIZE) {
				fprintf(stderr, "Length exceeded\n");
				return;
			}
			stack[top] = '(';
		} else if (*p == ')') {
			if (top >= 0) {
				--top;
			} else {
				fprintf(stderr, "Parenthesis mismatch\n");
				return;
			}
		}
		++p;
	}
	if (top >= 0)
		fprintf(stderr, "Parenthesis mismatch\n");
	putchar('\n');
}

int main() {
	paren("(1,(2,3),(4,(5,6),7))");
	return 0;
}