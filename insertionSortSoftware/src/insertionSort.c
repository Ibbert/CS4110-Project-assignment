/*
 * insertionSort.c: simple sort application by insertion
 *

 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include <stdlib.h>




void insertionSort(int tab[], int N);




void insertionSort(int tab[],int N){

    for(int i=1;i<N;i++){

        int j=i;
        while ((j>0)&(tab[j]<tab[j-1])){
            int tamp=tab[j];
            tab[j]=tab[j-1];
            tab[j-1]=tamp;
            j=j-1;
        }
    }
}



int main(){

    int N=10;
    int tab[10]={56,5,84,2,35,1,75,62,81,42};
    

    printf("\nUnsorted array:  ");
    for (int x=0;x<N;x++){
        printf("%d ",tab[x]);
    }
    printf("\n");

    insertionSort(tab,N);

    printf("Sorted array:  ");
    for (int x=0;x<N;x++){
        printf("%d ",tab[x]);
    }
    printf("\n");

    return 0;

}


