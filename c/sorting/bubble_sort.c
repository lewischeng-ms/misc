#include "sorting.h"

static void swap(int A[], int i, int j) {
	int temp = A[i];
	A[i] = A[j];
	A[j] = temp;
}

static int bubble_up(int A[], int begin, int end) {
	int changed = 0;

	int i;
	for (i = end - 1; i > begin; --i) {
		if (A[i] < A[i - 1]) {
			changed = 1;
			swap(A, i, i - 1);
		}
	}

	return changed;
}

void bubble_sort(int A[], int n) {
	int i;
	for (i = 0; i < n - 1; ++i) {
		int changed = bubble_up(A, i, n);
		if (!changed)
			break;
	}
}