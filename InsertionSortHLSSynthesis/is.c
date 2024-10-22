#include "is.h"

// Function to perform insertion sort
void is(int tab[], int N) {
#pragma HLS INTERFACE mode=s_axilite port=is
#pragma HLS INTERFACE mode=s_axilite port=arr
#pragma HLS INTERFACE mode=s_axilite port=output

    for(int i = 1; i < N; i++) {
        int j = i;
        while ((j > 0) & (tab[j] < tab[j - 1])) {
        int tamp = tab[j];
        tab[j] = tab [j - 1];
        tab[j - 1] = tamp;
        j = j - 1;
        }
    }
 }

