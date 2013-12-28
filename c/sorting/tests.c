#include <stdio.h>
#include <stdlib.h>

#include "sorting.h"

typedef void (*sort_type)(int A[], int n);

void print_int_array(int A[], int n) {
	printf("[ ");
	int i;
	for (i = 0; i < n; ++i)
		printf("%d ", A[i]);
	printf("]");
}

void test_case(sort_type sort, int A[], int n) {
	print_int_array(A, n);
	printf(" => ");
	sort(A, n);
	print_int_array(A, n);
	printf("\n");
}

void test_suite(const char *name, sort_type sort) {
	printf("Testing %s:\n", name);

	int *a0 = NULL;
	test_case(sort, a0, 0);

	int a1[1] = { 1 };
	test_case(sort, a1, 1);

	int a2[2] = { 2, 1 };
	test_case(sort, a2, 2);

	int a3[3] = { 2, 1, 3 };
	test_case(sort, a3, 3);

	int a4[10] = { -1, 7, 10, -8, 0, 9, 4, 5, 6, 3 };
	test_case(sort, a4, 10);

	int a5[9] = { 0, 1, 2, 3, 4, 5, 6, 7, 8 };
	test_case(sort, a5, 9);

	int a6[8] = { 9, 8, 7, 6, 5, 4, 3, 2 };
	test_case(sort, a6, 8);
}

void merge_sort_bind3th(int A[], int n) {
	static int T[1000];
	merge_sort(A, n, T);
}

int main() {
	test_suite("selection sort", selection_sort);
	test_suite("bubble sort", bubble_sort);
	test_suite("insertion sort", insertion_sort);
	test_suite("merge sort", merge_sort_bind3th);
	test_suite("quick sort", quick_sort);
	test_suite("heap sort", heap_sort);
	printf("All tests completed.\n");
	return 0;
}