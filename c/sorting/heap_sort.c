#include "sorting.h"

static void swap(int A[], int i, int j) {
	int temp = A[i];
	A[i] = A[j];
	A[j] = temp;
}

static int left_child(int root) {
	return root * 2 + 1;
}

static int right_child(int root) {
	return (root + 1) * 2;
}

static void sift_down(int A[], int begin, int end) {
	int root = begin;
	while (left_child(root) < end) {
		int next = root;

		int child = left_child(root);
		if (A[next] < A[child])
			next = child;

		child = right_child(root);
		if (child < end && A[next] < A[child])
			next = child;

		if (next == root)
			return; // no movement

		swap(A, root, next);
		root = next;
	}
}

static void heapify(int A[], int n) {
	// The last element that has child(s),
	// and thus needs sift down.
	// The root of the heap is A[i],
	// and the range is [i, n - 1].
	int root;
	for (root = (n - 2) / 2; root >= 0; --root)
		sift_down(A, root, n);
}

void heap_sort(int A[], int n) {
	heapify(A, n);

	while (n > 1) {
		swap(A, 0, n - 1);
		--n;
		sift_down(A, 0, n);
	}
}