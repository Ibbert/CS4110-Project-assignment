#include "fir.h"

#define N 8  // Number of elements to sort

// Function to perform insertion sort
void insertionSort(uint8_t arr[], uint8_t* output) {
#pragma HLS INTERFACE mode=s_axilite port=insertionSort
#pragma HLS INTERFACE mode=s_axilite port=arr
#pragma HLS INTERFACE mode=s_axilite port=output

    uint8_t i, key, j;

    for (i = 1; i < N; i++) {
        key = arr[i];
        j = i - 1;

        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = key;
    }

    // Copy the sorted array to the output (optional)
    for (i = 0; i < N; i++) {
        output[i] = arr[i];
    }
}
