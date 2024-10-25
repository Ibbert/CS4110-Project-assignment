#include "insertionSort.h"

#define N 8  // Define macro of the array size

void insertionSort(const uint8_t input[N], uint8_t output[N]) {
#pragma HLS INTERFACE mode=s_axilite port=insertionSort
#pragma HLS INTERFACE mode=s_axilite port=input
#pragma HLS INTERFACE mode=s_axilite port=output

    // Copy input array to output array for sorting
    for (int i = 0; i < N; i++) {
        output[i] = input[i];
    }

    // Perform insertion sort from output
    for (int i = 1; i < N; i++) {
        int j = i;
        while ((j > 0) && (output[j] < output[j - 1])) {
            // Swap values
            uint8_t temp = output[j];
            output[j] = output[j - 1];
            output[j - 1] = temp;
            j = j - 1;
        }
    }
}

/*
PREVIOUS CODE

#include "insertionSort.h"

#define n 8 

// Function to perform insertion sort
void insertionSort(uint8_t tab[], uint8_t N, uint8_t* inout) {
#pragma HLS INTERFACE mode=s_axilite port=insertionSort
#pragma HLS INTERFACE mode=s_axilite port=tab
#pragma HLS INTERFACE mode=s_axilite port=N
#pragma HLS INTERFACE mode=s_axilite port=inout 

    for (uint8_t i = 1; i < N; i++) {
        uint8_t j = i;
        printf("i:%d\n",tab[i]);
        while ((j > 0) && (tab[j] < tab[j - 1])) {
            printf("before:%d\n",tab[j]);
            uint8_t tamp = tab[j];
            tab[j] = tab[j - 1];
            tab[j - 1] = tamp;
            printf("after:%d\n",tab[j]);
            j = j - 1;
        }
    }
    
    inout = tab; 
}
*/
