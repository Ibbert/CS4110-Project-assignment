#include "fir.h"
#include <stdio.h>

int main() {
    uint8_t arr[8] = {4, 3, 5, 1, 2, 7, 6, 0};  // Example array to be sorted
    uint8_t sorted[8];

    printf("\nBefore sorting: ");
    for (int i = 0; i < 8; i++) {
        printf("%c ", arr[i]);
    }

    // Call the insertion sort function
    insertionSort(arr, sorted);

    printf("\nAfter sorting: ");
    for (int i = 0; i < 8; i++) {
        printf("%c ", sorted[i]);
    }

    printf("\n");
    return 0;
}
