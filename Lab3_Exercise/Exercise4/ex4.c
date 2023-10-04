#include<stdio.h>
#include<stdlib.h>

void merge(int *arr, int start, int mid, int end){
	int temp_size = end - start + 1;
	int *temp = new int[temp_size];  //variable temp length stored in stack

	for(int i = 0; i < temp_size;i++){
		temp[i] = arr[i+start];
	}
		

	int left_index = 0;
	int right_index = mid-start+1;
	int left_max = mid-start;
	int right_max = end-start;
	int arr_index = start;

	while(left_index <= left_max && right_index <= right_max){
		if(temp[left_index] <= temp[right_index]){
			arr[arr_index] = temp[left_index];
			arr_index++;
			left_index++;
		}
		else{
			arr[arr_index] = temp[right_index];
			arr_index++;
			right_index++;
		}
	}
    while(left_index <= left_max){
        arr[arr_index] = temp[left_index];
        arr_index++;
        left_index++;
    }
    while(right_index <= right_max){
        arr[arr_index] = temp[right_index];
        arr_index++;
        right_index++;
    }
}

void mergesort(int *arr, int start, int end){
	if(start < end){
		int mid = (end+start)/2;
		mergesort(arr, start, mid);
		mergesort(arr, mid+1, end);
		merge(arr, start, mid, end);
	}
}

int main(){
    int num_test = * (int *) 0x10000000;
    int *size =      (int *) 0x10000004;  
    int *test =      (int *) 0x10000004 + num_test;
    int *answer =    (int *) 0x01000000;

    for (int i = 0 ; i < num_test ; i++) {
        // test i
        int test_size = *(size++); 
        mergesort(test, 0, test_size-1);

        // Write answer
        
        for (int j = 0 ; j < test_size ; j++) {
            *(answer++) = *(test++);
        }
    }
	return 0;
}

/*
sub_loop_1:
    bge     t3, t4, endsubloop_1
    sw      t3, 0(t0)
    addi    t3, t3, 1
    slli    t5, t3, 2
    add     t0, a0, t5
    jal     x0, sub_loop_1

#################################################################
sub_loop_1:
    bge     t3, t4, endsubloop_1     # if(i > size), go to end_loop
    sw      t3, 0(t0)                # array[i] = answer     
    addi    t0, t0, 4                # arr++
    addi    t3, t3, 1                # i++
    jal     x0, sub_loop_1


endsubloop_1:
    lw      ra, 0(sp)
    addi    sp, sp, 4

    ret
#################################################################
*/