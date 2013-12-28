#include "sorting.h"

static void swap(int A[], int i, int j) {
	if (i != j) {
		int temp = A[i];
		A[i] = A[j];
		A[j] = temp;
	}
}

static int find_min_index(int A[], int begin, int end) {
	int j = begin;

	int i;
	for (i = begin + 1; i < end; ++i)
		if (A[i] < A[j])
			j = i;
	
	return j;
}

void selection_sort(int A[], int n) {
	int i;
	for (i = 0; i < n - 1; ++i) {
		int j = find_min_index(A, i, n);
		swap(A, i, j);
	}
}