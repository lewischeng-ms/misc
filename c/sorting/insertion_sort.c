#include "sorting.h"

static void do_insertion(int A[], int i) {
	int element = A[i];
	while (i > 0 && A[i - 1] > element) {
		A[i] = A[i - 1];
		--i;
	}
	A[i] = element;
}

void insertion_sort(int A[], int n) {
	int i;
	for (i = 1; i < n; ++i)
		do_insertion(A, i);
}