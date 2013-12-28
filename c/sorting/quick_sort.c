#include "sorting.h"

static void swap(int A[], int i, int j) {
	int temp = A[i];
	A[i] = A[j];
	A[j] = temp;
}

/* Version 1 - use A[0] as pivot
static int partition(int A[], int n) {
	int element = A[0];
	int p = 0, q = n - 1;
	int i = 1;
	while (p < q) {
		if (A[i] < element) {
			swap(A, p, i);
			++p;
			++i;
		} else {
			swap(A, q, i);
			--q;
		}
	}
	assert(p == q);

	A[p] = element;
	return p;
} */

/* Version 2 - use A[n - 1] as pivot */
static int partition(int A[], int n) {
	int element = A[n - 1];

	int p = 0;
	int i;
	for (i = 0; i < n - 1; ++i) {
		if (A[i] < element) {
			swap(A, i, p);
			++p;
		}
	}

	A[n - 1] = A[p];
	A[p] = element;
	return p;
}

void quick_sort(int A[], int n) {
	if (n < 2) return;

	int pivot_index = partition(A, n);

	quick_sort(A, pivot_index);
	quick_sort(A + pivot_index + 1, n - pivot_index - 1);
}