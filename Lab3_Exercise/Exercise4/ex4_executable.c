#include<stdio.h>
#include<stdlib.h>

void merge(int *arr, int start, int mid, int end) {
	int temp_size = end - start + 1;
	int *temp = new int[temp_size];  //variable temp length stored in stack

	for (int i = 0; i < temp_size; i++)
		temp[i] = arr[i + start];

	int left_index = 0;
	int right_index = mid - start + 1;
	int left_max = mid - start;
	int right_max = end - start;
	int arr_index = start;

	while (left_index <= left_max && right_index <= right_max) {
		if (temp[left_index] <= temp[right_index]) {
			arr[arr_index] = temp[left_index];
			arr_index++;
			left_index++;
		}
		else {
			arr[arr_index] = temp[right_index];
			arr_index++;
			right_index++;
		}
	}
	while (left_index <= left_max) {
		arr[arr_index] = temp[left_index];
		arr_index++;
		left_index++;
	}
	while (right_index <= right_max) {
		arr[arr_index] = temp[right_index];
		arr_index++;
		right_index++;
	}
}

void mergesort(int *arr, int start, int end) {
	if (start < end) {
		int mid = (end + start) / 2;
		mergesort(arr, start, mid);
		mergesort(arr, mid + 1, end);
		merge(arr, start, mid, end);
	}
}

int main() {
	const int TEST1_SIZE = 34;
	const int TEST2_SIZE = 19;
	const int TEST3_SIZE = 29;
	int test1[TEST1_SIZE] = { 3,41,18,8,40,6,45,1,18,10,24,46,37,23,43,12,3,37,0,15,11,49,47,27,23,30,16,10,45,39,1,23,40,38 };
	int test2[TEST2_SIZE] = { -3,-23,-22,-6,-21,-19,-1,0,-2,-47,-17,-46,-6,-30,-50,-13,-47,-9,-50 };
	int test3[TEST3_SIZE] = { -46,0,-29,-2,23,-46,46,9,-18,-23,35,-37,3,-24,-18,22,0,15,-43,-16,-17,-42,-49,-29,19,-44,0,-18,23 };

	mergesort(test1, 0, TEST1_SIZE - 1);
	mergesort(test2, 0, TEST2_SIZE - 1);
	mergesort(test3, 0, TEST3_SIZE - 1);

	for (int i = 0; i < TEST1_SIZE; i++)
		printf("%d, ", test1[i]);
	printf("\n");

	for (int i = 0; i < TEST2_SIZE; i++)
		printf("%d, ", test2[i]);
	printf("\n");

	for (int i = 0; i < TEST3_SIZE; i++)
		printf("%d, ", test3[i]);
	printf("\n");

	return 0;
}