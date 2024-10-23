#include "insertionSort.h"

#define n 8 

// Function to perform insertion sort
int* insertionSort(int tab[], int N) {
#pragma HLS INTERFACE mode=s_axilite port=tab
#pragma HLS INTERFACE mode=s_axilite port=N
#pragma HLS INTERFACE mode=s_axilite port=return

    for (int i = 1; i < N; i++) {
        int j = i;
        while ((j > 0) && (tab[j] < tab[j - 1])) {
            int tamp = tab[j];
            tab[j] = tab[j - 1];
            tab[j - 1] = tamp;
            j = j - 1;
        }
    }
    return tab; 
}
