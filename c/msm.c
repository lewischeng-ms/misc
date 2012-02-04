#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// #define NDEBUG

#define SEARCH_SUB_MATRIX(P, Q) \
	if (search_sub_matrix(a, m, n, P, Q, k)) \
		return 1
		
#ifndef NDEBUG
int search_count = 0;
#endif
		
void print_sub_matrix(int**a, int w, int x, int y, int z)
{
	int y0 = y;
	while (w <= x)
	{
		while (y <= z)
		{
			printf("%3d ", a[w][y]);
			++y;
		}
		printf("\n");
		y = y0;
		++w;
	}
}

int sum_sub_matrix(int** a, int w, int x, int y, int z)
{
	int sum = 0;
	int y0 = y;
	while (w <= x)
	{
		while (y <= z)
		{
			sum += a[w][y];
			++y;
		}
		y = y0;
		++w;
	}
	
	return sum;
}

int search_sub_matrix(int** a, int m, int n, int p, int q, int k)
{
	int w, x, y, z;
	for (w = 0; w <= m - p; ++w)
	{
		x = w + p - 1;
		for (y = 0; y <= n - q; ++y)
		{
			z = y + q - 1;
#ifndef NDEBUG
			++search_count;
#endif
			int sum = sum_sub_matrix(a, w, x, y, z);
			if (sum >= k)
			{
				printf("The minimal sub matrix is:\n");
				// print_sub_matrix(a, w, x, y, z);
				printf("M: [%d, %d]->[%d, %d].\n", w, y, x, z);
				return 1;
			}
		}
	}
	
	return 0;
}

int minimal_sub_matrix(int** a, int m, int n, int k)
{
	if (m < 1 || n < 1) return 0;
	
	int l;
	for (l = 1; l <= m * n; ++l)
	{
		int p;
		for (p = 1; p <= m; ++p)
		{
			if (l % p == 0)
				SEARCH_SUB_MATRIX(p, l / p);
		}
	}
	
	return 0;
}

int main()
{
	srand(time(NULL));
	
	int m = 40;
	int n = 40;
	int k = 450;
	int** a = calloc(m, sizeof(int*));
	int i;
	for (i = 0; i < m; ++i)
	{
		a[i] = calloc(n, sizeof(int));
		int j;
		for (j = 0; j < n; ++j)
			a[i][j] = rand() % 101 - 50;
	}
	// printf("The matrix is:\n");
	// print_sub_matrix(a, 0, m - 1, 0, n - 1);

	clock_t begin = clock();
	if (!minimal_sub_matrix(a, m, n, k))
		printf("The minimal sub matrix does not exist.\n");
	clock_t end = clock();
	printf("Time consumed: %d ms.\n", end - begin);
		
#ifndef NDEBUG
	printf("A total of %d matrix has been searched.\n", search_count);
#endif

	return 0;
}