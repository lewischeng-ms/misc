#include "sorting.h"

static void merge(int A[], int n, int B[], int k, int T[]) {
	int i = 0, j = 0;
	int count = 0;
	while (i < n && j < k) {
		if (A[i] < B[j]) {
			T[count] = A[i++];
		} else {
			T[count] = B[j++];
		}
		++count;
	}

	while (i < n)
		T[count++] = A[i++];
	while (j < k)
		T[count++] = B[j++];

	for (i = 0; i < count; ++i)
		A[i] = T[i];
}

void merge_sort(int A[], int n, int T[]) {
	if (n < 2) return;

	int mid = (n - 1) / 2;

	int first_half = mid + 1;
	merge_sort(A, first_half, T);

	int *B = A + first_half;
	int second_half = n - first_half;
	merge_sort(B, second_half, T);

	merge(A, first_half, B, second_half, T);
}
