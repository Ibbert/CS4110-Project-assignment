# RISC-V assembly code for selection sorting

# Registers used in main code:
# a0 = array address (first element)
# a1 = array size (number of elements)
# a2 = current minimum returned by subroutine
# a3 = pointer to current minimum
# a4 = swap buffer
# a5 = 1 (used to stop the loop in the main program)

# Registers used in subroutine:
# t0 = current (temporary) minimum
# t1 = address of the current minimum
# t2 = current array element
# t3 = index to scan the array
# t4 = offset to add to array pointer (32-bit array elements)
# t5 = temporary pointer to array

.data
array: .word 7, 3, 5, 6, 1, 3, 2, 9, 6, 2, 5, 7, 1
.eqv   size, 13

.text 
start:
     la   a0,array   	# set array pointer to begin of array
     li   a1,size     	# set size of array
     li   a5,1		# to compare and stop when the rest to scan is just one
loop:
     jal  ra,find_min
     lw   a4,0(a0)	# retrieve current element being analyzed
     sw	  a2,0(a0)	# store current minimum in ordered position
     sw   a4,0(a3)	# store analyzed element into where current minimum was
     addi a0,a0,4	# update initial scanning address
     beq  a1,a5,stop	# stop when there is only one element left
     addi a1,a1,-1	# decrement number of elements to analyze
     j    loop
stop:
#    j    stop
     li   a7,10
     ecall

find_min: 
     lw   t0,0(a0)   	  # set first element as the initial minimum value 
     mv   t1,a0		  # set address of current minimum
     li   t3,1            # set initial value of index to scan the array  
subloop:
     beq  t3,a1,exit  	  # reached the end of the array? 
     slli t4,t3,2     	  # multiply index by 4 (32-bit elements) 
     addi t3,t3,1     	  # increment index to array      
     add  t5,a0,t4    	  # update address to next element 
     lw   t2,0(t5)    	  # read current element into t2
     bgt  t2,t0,subloop   # continue to next element if no new minimum
     mv   t0,t2       	  # set current element as new minimum otherwise
     mv   t1,t5		  # save address of the current minimum to t1
     j    subloop    	  # continue to next if no new maximum was found 
exit: 
     mv   a2,t0       	  # return minimum value 
     mv   a3,t1		  # return address of minimum value
     ret
