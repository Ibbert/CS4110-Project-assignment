// I wrote this code, only God and I knew how it worked.
// Now, only God knows. 
#include <sys/types.h>
#define N_max 50 
#define N 8

#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <xparameters.h>
#include "xinsertionsort.h"
#include "platform.h"
#include "xil_printf.h"

int main()
{
    init_platform();

    printf("\nInsertion sorting\n\r");

    XInsertionsort insertsort =
    {
        // XPAR_XFIR_0_BASEADDR might need to be changed. 
        // The parameter can be found in xparameters.h
        // For our board (Zynq 7000) the value should be 0x40000000
        .Control_BaseAddress = XPAR_INSERTIONSORT_0_BASEADDR, 
        .IsReady = 0
    };
    
    XInsertionsort_Config* const config = XInsertionsort_LookupConfig(XPAR_XSLCR_0_DEVICE_ID);
    const int ret = XInsertionsort_CfgInitialize(&insertsort, config);
    Xil_AssertNonvoid(ret == XST_SUCCESS);

    XInsertionsort_DisableAutoRestart(&insertsort);

    char c_table[2*N_max];
    int c_cnt=0;

while(1) {
        const char c= inbyte();
        if(c=='\r'){
            printf("list:%s \n",c_table);
            printf("one by one:\n");

            int k=0;
            while (c_table[k] !='\0'){                
                printf("k:%d ;%c\n",k,c_table[k]);
                k++;
            }

            char* int_array="[";
            for (k=0;k<c_cnt;k++){
                int_array+=c_table[k];
            }
            
            /*
            uint8_t int_array[N_max];
            for (k=c_cnt;k<2*N_max;k++){
                c_table[k]=NULL;
            }
            char* token= strtok(c_table,",");
            int cnt=0;
            while (token!=NULL & token!='\0'){
                int_array[cnt]=(uint8_t)atoi(token);
                printf("newtoken:%s  :atoi:%d : cnt:%d\n",token,int_array[cnt],cnt);
                token=strtok(NULL,",");
                cnt++;
            }
            */

            // printf("cnt:%d!\n",cnt);
            printf("blo\n");
            if(XInsertionsort_IsIdle(&insertsort))
            {
                XInsertionsort_Write_input_r_Bytes(&insertsort, 0, int_array, sizeof(int_array));
                XInsertionsort_Start(&insertsort);
                while(!XInsertionsort_IsDone(&insertsort));

                printf("From small to large:\n");
                uint8_t* val = XInsertionsort_Get_output_r(&insertsort);
                //for (int i=0; i<cnt;i++){
                //    printf("n%d:%d\n",i,val[i]);
                //} 
                *val = 0;                 
                printf("end\n");
                char c_table[50];
                //cnt=0;
                c_cnt=0;
            }
        }else{
            c_table[c_cnt]=c;
            c_cnt++;
            printf("strlen:%d ;len-1: %c\n",strlen(c_table),c_table[strlen(c_table)-1]);
        }
    }
    cleanup_platform();
    return 0;
}
