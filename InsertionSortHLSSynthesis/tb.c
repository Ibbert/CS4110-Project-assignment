#include "insertionSort.h"
#include <stdio.h>

// I wrote this code, only God and I knew how it worked.
// Now, only God knows. 
// You will see full result when debugging or spamming runs.

int main() {
    int N = 12;  // Define the size of the array
    int arr[] = {9, 10, 2, 1, 0, 3, 5, 6, 4, 8, 11, 7};  // Example unsorted array
    printf("Testing of array");
    printf("\n");

    // Before sorting
    printf("\nBefore sorting: ");
    for(int i = 0; i < N; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");


    // Call the insertion sort function
    insertionSort(arr, N);

    // After sorting
    printf("\nAfter sorting: ");
    for(int i = 0; i < N; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    return 0;
}
