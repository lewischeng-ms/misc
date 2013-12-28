#ifndef SORTING_H_INCLUDED
#define SORTING_H_INCLUDED

#include <assert.h>
#include <stdlib.h>

// selection sortings
void selection_sort(int A[], int n);
void heap_sort(int A[], int n);

// exchange sorts
void bubble_sort(int A[], int n);
void quick_sort(int A[], int n);

// insertion sorts
void insertion_sort(int A[], int n);

// merge sorts
void merge_sort(int A[], int n, int T[]);

#endif // SORTING_H_INCLUDED