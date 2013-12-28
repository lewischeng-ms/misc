#include <stdio.h>

int bins1(int *array, int size, int key) {
	int low = 0;
	int high = size - 1;
	while (low <= high) {
		int mid = ((high - low) >> 1) + low;
		if (array[mid] == key)
			return mid;
		else if (array[mid] < key)
			low = mid + 1;
		else
			high = mid - 1;
	}
	return low; // low上一次比key小，+1以后就是key该插入的位置
}

int bins(int *array, int size, int key) {
	int low = 0;
	int high = size - 1;
	while (low <= high) {
		int mid = ((high - low) >> 1) + low;
		if (array[mid] == key)
			return mid;
		else if (array[mid] < key)
			low = mid + 1;
		else
			high = mid - 1;
	}
	return -1;
}

int binsr(int *array, int size, int key) {
	int low = 0;
	int high = size - 1;
	while (low <= high) {
		int mid = ((high - low) >> 1) + low;
		if (array[mid] == key)
			return mid;
		else if (array[mid] > key)
			low = mid + 1;
		else
			high = mid - 1;
	}
	return -1;
}

// array先增后减
int bins2(int *array, int size, int key) {
	int low = 0;
	int high  = size - 1;

	int max = 0;
	while (low <= high) {
		max = ((high - low) >> 1) + low;
		if (array[max] >= array[low] && array[max] >= array[high])
			break;
		if (array[max] < array[low])
			high = max - 1;
		if (array[max] < array[high])
			low = max + 1;
	}

	if (array[max] == key)
		return max;

	if (array[max] < key)
		return -1;

	int res1 = bins(array, max, key);
	int res2 = binsr(array + max + 1, size - max - 1, key);

	if (res1 != -1)
		return res1;
	if (res2 != -1)
		return res2 + max + 1;
	return -1;
}

int main() {
	int arr0[] = { 1, 2, 4, 5 };
	printf("%d\n", bins1(arr0, 4, 3));
	int arr1[] = { 1, 2, 4, 5, 6 };
	printf("%d\n", bins1(arr1, 5, 3));
	int arr2[] = { 1, 2, 4, 5, 6 };
	printf("%d\n", bins1(arr2, 5, 2));
	int arr3[] = { 1 };
	printf("%d\n", bins1(arr3, 1, 0));
	int arr4[] = {  };
	printf("%d\n", bins1(arr4, 0, 0));

	printf("******************\n");

	int arr5[] = { 1, 2, 6, 5, 4, 3, 2, 1 };
	printf("%d\n", bins2(arr5, 8, 3));
	return 0;
}