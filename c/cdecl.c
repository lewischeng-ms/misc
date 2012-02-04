#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#pragma warning (disable : 4996)

#define MAXTOKENS 100
#define MAXTOKENLEN 64

enum type_tag{IDENTIFIER, QUALIFIER, TYPE}; /*标识符，限定符，类型*/

struct token{
	char type;
	char string[MAXTOKENLEN];
};

int top = -1;
struct token stack[MAXTOKENS];
struct token this;

#define pop stack[top--]
#define push(s) stack[++top] = s

#define STRCMP(a,R,b) (strcmp(a,b) R 0)

/*推断标识符类型*/
enum type_tag classify_string(void)
{
	char *s = this.string;
	if (STRCMP(s,==,"const"))
	{
		strcpy(s,"read-only");
		return QUALIFIER;
	}
	if (STRCMP(s,==,"volatile")) return QUALIFIER;
	if (STRCMP(s,==,"void")) return TYPE;
	if (STRCMP(s,==,"char")) return TYPE;
	if (STRCMP(s,==,"signed")) return TYPE;
	if (STRCMP(s,==,"unsigned")) return TYPE;
	if (STRCMP(s,==,"short")) return TYPE;
	if (STRCMP(s,==,"int")) return TYPE;
	if (STRCMP(s,==,"long")) return TYPE;
	if (STRCMP(s,==,"double")) return TYPE;
	if (STRCMP(s,==,"float")) return TYPE;
	if (STRCMP(s,==,"struct")) return TYPE;
	if (STRCMP(s,==,"union")) return TYPE;
	if (STRCMP(s,==,"enum")) return TYPE;
 	return IDENTIFIER;
}

/*读取下一个标记到"this"
*可能读入的字符包括：字母、数字、*[]()
*/
void gettoken(void)
{
	char *p = this.string;
	
	/*略过空白字符*/
	while((*p = (char)getchar()) == ' ') ;
	
	/*是字母或数字*/
	if (isalnum(*p))
	{
		while(isalnum(*++p = (char)getchar())) ; /*读到下一个不是字母或数字为止*/
		ungetc(*p,stdin);  /*将一个字符回退到输入流*/
		*p = '\0';
		this.type = (char)classify_string();
		return;
	}
	
	if (*p == '*')
	{
		strcpy(this.string,"pointer to");
		this.type = '*';
		return;
	}
	
	this.string[1] = '\0';
	this.type = *p;
	return;
}

/*理解所有分析过程的代码段*/
int read_to_first_identifier(void)
{
	gettoken(); /*取第一个标记*/
	while(this.type != (char)IDENTIFIER) /* 取到标识符终止，标识符未压入栈 */
	{
		push(this);
		gettoken();
	}
	
	printf("%s is ",this.string);
	gettoken();/*再取标识符右边一个符号*/
	return 0;
}

int deal_with_arrays(void)
{
	while(this.type == '[')
	{
		printf("array ");
		gettoken();/*数字域或']'*/
		if (isdigit(this.string[0]))
		{
			printf("0..%d ",atoi(this.string)-1);
			gettoken(); /*取']'*/
		}
		
		gettoken(); /* 读取']'后的下一个标记，可能还是一个'[' */
		printf("of ");
	}
	
	return 0;
}

int deal_with_function_args(void)
{
	while(this.type != ')') /* 把函数参数取出来丢弃 */
	{
		gettoken();
	}
	
	gettoken(); /* 读取')'后的下一个标记 */
	printf("function returning ");
	return 0;
}

int deal_with_pointers(void)
{
	while(stack[top].type == '*')
	{
		printf("%s ",pop.string);
	}
	return 0;
}

int deal_with_declarator(void)
{
	/*处理标识符后可能存在的数组或函数*/
	switch(this.type)
	{
		case '[' : deal_with_arrays();break;
		case '(' : deal_with_function_args();break;
		default : break;
	}
	
	deal_with_pointers(); /* 栈顶元素是'*' */
	
	/*处理在读到标识符之前压入堆栈的符号*/
	while(top >= 0)
	{
		if (stack[top].type == '(')
		{
			pop;
			gettoken(); /* 读取')'之后的符号，可能是'('或'[' */
			deal_with_declarator();  /* 递归调用 */
		}
		else
		{
			printf("%s ",pop.string);
		}
	}
	
	return 0;
}

int main(void)
{
	/*将标记压入堆栈中，直到遇见标识符*/
	read_to_first_identifier();
	deal_with_declarator();
	printf("\n");
	
	return 0;
}
