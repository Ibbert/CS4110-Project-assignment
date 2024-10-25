#include <stdio.h>
#include <stdint.h>
#include "insertionSort.h"

#define N 8  // Define the array size for testing

int main() {
    uint8_t input_array[N] = {34, 7, 23, 32, 5, 62, 43, 17};
    uint8_t output_array[N]; 

    printf("Unsorted array:\n");
    for (int i = 0; i < N; i++) {
        printf("%d ", input_array[i]);
    }
    printf("\n");

    // Call function
    insertionSort(input_array, output_array);

    printf("Sorted array:\n");
    for (int i = 0; i < N; i++) {
        printf("%d ", output_array[i]);
    }
    printf("\n");

    return 0;
}
