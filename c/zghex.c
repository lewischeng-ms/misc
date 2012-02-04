#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OK 0
#define SHIT 1

#define YES 1
#define NO 0

#define MAX_COMMAND_SIZE 100
#define EDIT_BUFFER_SIZE 256
#define BYTES_EACH_LINE 16

#define QUIT_EDITOR 12345

typedef unsigned char uchar;

int interaction(const char *);
int parse_and_execute();

void show_help();
int parse_number();
int get_hex(uchar);
int parse_xnumber();
int check_file_size();
int brute_force_find_string(int);

void write_back_edit_buffer(int);
void switch_edit_buffer(int);
void show_edit_buffer();
void fill_edit_buffer();

FILE * strm;
int file_size;

uchar command_buffer[MAX_COMMAND_SIZE];
uchar * cbptr;	// Pointer to command buffer.

uchar edit_buffer[EDIT_BUFFER_SIZE];
uchar * ebptr; // Pointer to edit buffer.
int ebmodified; // If the content in the buffer has been modified.
int ebsize; // Actual bytes in the buffer.
int ebo;	// Offset of edit buffer in the file.

int main(int argc, char * argv[])
{
	printf("曾哥十六进制编辑器\n作者：成立  日期：2011/2/2\n\n");
	switch (argc)
	{
	case 1:
		printf("用法：zghex <filename>\n");
		return OK;

	case 2:
		printf("文件名：\"%s\"\n", argv[1]);
		strm = fopen(argv[1], "r+b");
		if (!strm)
		{
			printf("错误：文件打不开！SHIT！！！你知道耍曾哥的后果~\n");
			return SHIT;
		}
		if (check_file_size() == SHIT) return SHIT;
		fill_edit_buffer();
		printf("开始输入命令吧！输入\'?\'显示帮助。\n");
		return interaction(argv[1]);

	default:
		printf("哥不接受%d个启动参数。\n", argc - 1);
		return SHIT;
	}

	return OK;
}

int interaction(const char * filename)
{
	for (;;)
	{
		printf("\n>");
		scanf("%s", command_buffer);
		if (command_buffer[MAX_COMMAND_SIZE - 1] != 0)
		{
			printf("错误：输入的命令太长。\n");
			continue;
		}
		cbptr = command_buffer;
		int ret = parse_and_execute();
		if (ret == QUIT_EDITOR) break;
		if (ret == OK) printf("搞定！\n");
	}
	printf("狗得白！愿曾哥与你同行！\n");
	return OK;
}

int parse_and_execute()
{
	int arg1;
	int new_ebo;

	if (strcmp(cbptr, "w") == 0)
	{
		write_back_edit_buffer(NO);
		return OK;
	}

	if (strcmp(cbptr, "p") == 0)
	{
		new_ebo = ebo - EDIT_BUFFER_SIZE;
		if (new_ebo < 0)
		{
			printf("错误：到达文件首部。\n");
			return SHIT;
		}
		switch_edit_buffer(new_ebo);
		return OK;
	}

	if (strcmp(cbptr, "q") == 0)
	{
		write_back_edit_buffer(YES);
		fclose(strm);
		return QUIT_EDITOR;
	}

	if (strcmp(cbptr, "s") == 0)
	{
		show_edit_buffer();
		return OK;
	}

	if (strcmp(cbptr, "?") == 0)
	{
		show_help();
		return OK;
	}

	if (*cbptr == 'n')
	{
		if (strcmp(cbptr, "n") == 0)
		{
			new_ebo = ebo + EDIT_BUFFER_SIZE;
			if (new_ebo >= file_size)
			{
				printf("错误：到达文件尾。\n");
				return SHIT;
			}
		}
		else if (strcmp(cbptr, "nn") == 0)
		{
			new_ebo = file_size & 0xFFFFFF00;
		}
		else
		{
			printf("错误：哥不晓得这命令。\n");
			return SHIT;
		}

		switch_edit_buffer(new_ebo);
		return OK;
	}

	if (*cbptr == 'm')
	{
		++cbptr; // Match 'm'.

		if (!isxdigit(*cbptr))
		{
			printf("错误：\'m\'命令后只能跟十六进制数。\n");
			return SHIT;
		}
		arg1 = parse_xnumber();
		if (arg1 > 0xFFFF)
		{
			printf("错误：\'m\'命令只接受4个十六进制位。\n");
			return SHIT;
		}

		int hi = arg1 >> 8;
		int lo = arg1 & 0xFF;
		edit_buffer[hi] = lo;
		if (hi >= ebsize)
		{
			file_size += hi + 1 - ebsize;
			ebsize = hi + 1;
		}
		ebmodified = YES;

		show_edit_buffer();
		return OK;
	}

	if (*cbptr == 'o')
	{
		++cbptr;	// Match 'o'.

		write_back_edit_buffer(YES);
		printf("文件名：\"%s\"\n", cbptr);
		FILE * new_strm = fopen(cbptr, "r+b");
		if (!new_strm)
		{
			printf("错误：文件打不开！SHIT！！！你知道耍曾哥的后果~\n");
			return SHIT;
		}
		fclose(strm);
		strm = new_strm;
		if (check_file_size() == SHIT) return SHIT;

		ebo = 0;
		fill_edit_buffer();
		return OK;
	}

	if (*cbptr == 'd')
	{
		++cbptr; // Match 'd'.

		if (!isxdigit(*cbptr))
		{
			printf("错误：\'d\'后只能跟一个十六进制数。\n");
			return SHIT;
		}
		arg1 = parse_xnumber();
		printf("十六进制数为：%d。\n", arg1);
		return OK;
	}

	if (*cbptr == 'h')
	{
		++cbptr; // Match 'h'.

		if (*cbptr == '\'')
		{
			++cbptr;
			arg1 = *cbptr++;
			if (*cbptr++ != '\'')
			{
				printf("错误：字符必须以单引号结尾。\n");
				return SHIT;
			}
		}
		else if (isdigit(*cbptr))
		{
			arg1 = parse_number();
		}
		else
		{
			printf("错误：\'h\'后只能跟一个十进制数或单引号括起来的字符。\n");
			return SHIT;
		}

		printf("十六进制数为：0x%x。\n", arg1);
		return OK;
	}

	if (*cbptr == 'l')
	{
		if (strcmp(cbptr, "l") == 0)
		{
			++cbptr;	// Match 'l'.
			switch_edit_buffer(0);
		}
		else
		{
			++cbptr;	// Match 'l'.

			if (!isxdigit(*cbptr))
			{
				printf("错误：\'l\'后只能跟十六进制数.\n");
				return SHIT;
			}
			arg1 = parse_xnumber();
			if (file_size > 0 && arg1 >= file_size ||
					file_size == 0 && arg1 > 0)
			{
				printf("错误：偏移0x%x超出文件大小：0x%x 字节。\n", arg1, file_size);
				return SHIT;
			}
			switch_edit_buffer(arg1 & 0xFFFFFF00);
		}
		return OK;
	}

	if (*cbptr == 'f')
	{
		++cbptr;	// Match 'f'.

		if (*cbptr != '+')
		{
			fseek(strm, ebo, SEEK_SET);
		}
		else
		{
			++cbptr; // Match '+'.
		}

		uchar * p;
		if (*cbptr == '\"')
		{
			++cbptr; // Match '"'.

			// Make the other '"' zero so that string-functions can be used.
			p = cbptr;
			while (*p && *p != '\"')
				++p;
			if (*p == 0)
			{
				printf("错误：字符串必须以\"结尾。\n");
				return SHIT;
			}
			*p = 0;
		}
		else if (isxdigit(*cbptr))
		{
			p = cbptr;
			char * q = cbptr;
			for (;;)
			{
				int d = get_hex(*q);
				if (d == -1) break;
				arg1 = d << 4;
				d = get_hex(*(q + 1));
				if (d == -1)
				{
					*p++ = arg1;
					break;
				}
				arg1 += d;
				*p++ = arg1;
				q += 2;
			}
			*p = 0;
		}
		else
		{
			printf("错误：\'f\'后只能跟十六进制数或双引号括起来的字符串。\n");
			return SHIT;
		}

		printf("查找的起始偏移：0x%08x。\n", ftell(strm));
		int offset = brute_force_find_string(p - cbptr);
		if (offset == -1)
		{
			printf("错误：指定的内容没有找到。\n");
			return SHIT;
		}
		printf("已找到，偏移：0x%08x。\n", offset);
		*cbptr = 0;
		switch_edit_buffer(offset & 0xFFFFFF00);
		return OK;
	}

	printf("错误：哥不认识这命令。\n");
	return SHIT;
}

void show_help()
{
	printf(">>>>>>>>>>>>>>>>>>>>>>>>>>> 帮助 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
	printf("哥一共支持12条命令：\n");
	printf("1. 打开和保存:\n"
				 "(1). o<filename>，在编辑器中打开<filename>文件。\n"
				 "(2). w，把当前页的修改写回文件。\n");
	printf("2. 浏览文件:\n"
				 "(1). l[<hex>]，载入偏移<hex>所在的那个页。\n"
				 "     如果<hex>省略，默认为0。\n"
				 "(2). n，显示下一页。\n"
				 "(3). nn，显示最后一页。\n"
				 "(4). p，显示前一页。\n"
				 "(5). s，显示当前页。\n");
	printf("3. 修改:\n"
				 "(1). m<两位hex><两位hex>，第一个<hex>指明了在当前页中的位置，\n"
				 "     第二个<hex>指明了新的内容。\n");
	printf("4. 查找:\n"
				 "(1). f[+]{<hex> | \"<str>\"}，从当前页开始找<hex>。\n"
				 "     如果有\'+\'，就从上次位置开始搜索。\n");
	printf("5. 实用工具:\n"
				 "(1). d<hex>，把<hex>转换成十进制。\n"
				 "(2). h<dec>，把<dec>转换成十六进制。\n"
				 "     h\'<char>\'，把<char>转换成十六进制。\n");
	printf("6. 编辑器:\n"
				 "(1). q，退出编辑器。\n");
	printf("注：命令解释器会自动忽略一条完整命令后面的废话。\n");
}

int parse_number()
{
	int ret = 0;
	while (isdigit(*cbptr))
	{
		ret *= 10;
		ret += (*cbptr++) - '0';
	}

	return ret;
}

int get_hex(uchar ch)
{
	if (ch >= '0' && ch <= '9')
		return ch - '0';
	else if (ch >= 'A' && ch <= 'F')
		return ch - 'A' + 10;
	else if (ch >= 'a' && ch <= 'f')
		return ch - 'a' + 10;
	else
		return -1;
}

int parse_xnumber()
{
	int ret = 0;
	for (;; ++cbptr)
	{
		int d = get_hex(*cbptr);
		if (d == -1) break;
		ret *= 16;
		ret += d;
	}

	return ret;
}

int check_file_size()
{
	fseek(strm, 0, SEEK_END);
	file_size = ftell(strm);
	fseek(strm, 0, SEEK_SET);
	if (file_size < 0)
	{
		printf("错误：文件太大，哥处理不了。\n");
		return SHIT;
	}
	printf("文件大小：0x%x 字节。\n", file_size);
	return OK;
}

int brute_force_find_string(int size)
{
	if (size < 1) return -1;

	for (;;)
	{
		int offset = ftell(strm);
		int i;
		for (i = 0; i < size; ++i)
		{
			uchar ch = fgetc(strm);
			if (ch != cbptr[i]) break;
		}
		// Found.
		if (i == size)
			return offset;
		if (feof(strm))
			return -1;
		fseek(strm, offset + 1, SEEK_SET);
	}
}

//////////////////////////////////////////////////////////////////////////

void write_back_edit_buffer(int need_ask)
{
	if (ebmodified == YES)
	{
		if (need_ask == YES)
		{
			char ans[2];
			printf("当前页已被修改，是否将其写回？[y/N]");
			scanf("%s", ans);
			if (ans[0] != 'y')
				return;
		}
		int old_offset = ftell(strm);
		fseek(strm, 0, ebo);
		fwrite(edit_buffer, 1, ebsize, strm);
		fflush(strm);
		fseek(strm, old_offset, SEEK_SET);
		ebmodified = NO;
	}
}

void switch_edit_buffer(int new_ebo)
{
	if (ebo != new_ebo)
	{
		write_back_edit_buffer(YES);
		ebo = new_ebo;
	}
	fill_edit_buffer();
	show_edit_buffer();
}

void show_edit_buffer()
{
	printf("当前页偏移：0x%x, 文件大小：0x%x 字节。\n", ebo, file_size);
	int i, j;
	printf("B7-B1\\B0| ");
	for (j = 0; j < BYTES_EACH_LINE; ++j)
		printf("%2X ", j);
	printf("\n--------+------------------------------------------------\n");

	for (i = 0; i < EDIT_BUFFER_SIZE / BYTES_EACH_LINE; ++i)
	{
		int line_index = i * BYTES_EACH_LINE;
		int line_offset = ebo + line_index;
		printf("%06X %X| ", line_offset >> 8, (line_offset & 0xF0) >> 4);
		for (j = 0; j < BYTES_EACH_LINE; ++j)
			printf("%02X ", edit_buffer[line_index + j]);
		for (j = 0; j < BYTES_EACH_LINE; ++j)
		{
			uchar ch = edit_buffer[line_index + j];
			if (!isgraph(ch))
				printf(".");
			else
				printf("%c", ch);
		}
		printf("\n");
	}
}

void fill_edit_buffer()
{
	int old_offset = ftell(strm);
	fseek(strm, ebo, SEEK_SET);
	ebsize = fread(edit_buffer, 1, EDIT_BUFFER_SIZE, strm);
	fseek(strm, old_offset, SEEK_SET);
	int cnt = ebsize;
	while (cnt < EDIT_BUFFER_SIZE)
		edit_buffer[cnt++] = 0;
	ebmodified = NO;
}
