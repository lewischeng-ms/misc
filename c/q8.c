#include <stdio.h>
#include <time.h>

#define N 16 // 皇后个数。

int scnt = 0; // 解数。
int pos[N]; // 每行皇后的位置。
int col[N]; // 列占用数组。
int pdiag[2 * N]; // 主对角线占用数组。
int cdiag[2 * N]; // 副对角线占用数组。

void print_solution()
{
	int i, j;
	for (i = 0; i < N; ++i)
	{
		for (j = 0; j < N; ++j)
		{
			if (j == pos[i])
			{
				putchar('*');
			}
			else
			{
				putchar('_');
			}
			putchar(' ');
		}
		putchar('\n');
	}
	puts("\n");
}

void queen(int i)
{
	if (i == N)
	{ // 找到一个解。
		// print_solution();
		++scnt;
	}
	else
	{ // 尝试在第i行放皇后。
		int j;
		for (j = 0; j < N; ++j)
		{ // 在每一列尝试放置皇后，以找到所有解。
			if (!col[j] && !pdiag[i + j] && !cdiag[i - j + N - 1])
			{ // 在(i, j)放置皇后没有冲突。
				// 在(i, j)放置皇后。
				pos[i] = j;

				// 宣布占领第j列和该皇后所在的两条对角线。
				col[j] = pdiag[i + j] = cdiag[i - j + N - 1] = 1;

				// 继续在第i + 1行放皇后。
				queen(i + 1);

				// 释放对第j列和该皇后所在的两条对角线的占领。
				col[j] = pdiag[i + j] = cdiag[i - j + N - 1] = 0;
			}
		}
	}
}

int main()
{
	clock_t st = clock();
	queen(0);
	clock_t en = clock();
	printf("一共%d个解，花费时间：%.3lf秒。\n", scnt, (en - st) / 1000.0);
	return 0;
}