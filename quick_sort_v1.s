////////////////////////
//                    //
// Project Submission //
//                    //
////////////////////////

// Partner1: (your name here), (Student ID here)
// Partner2: (your name here), (Student ID here)

////////////////////////
//                    //
//       main         //
//                    //
////////////////////////

    // You can modify main function to test your own test cases.
	// The folloiwng prints unsorted list, call sort function, and print the sorted list again.
    lda x0, list1      // display original list
    bl printList

	addi x0, xzr, #10  // \n new line
	putchar x0

    lda x0, list1
    bl QuickSortWrapper  // return sorted list in x1
    add x0, x1, XZR
    bl printList         // entirely sorted

	stop


////////////////////////
//                    //
//   SwapNodeValue    //
//                    //
////////////////////////
SwapNodeValue:
	// input:
    //     x0: The address of (pointer to) one node (corresponding to n1) on the linked list.
    //     x1: The address of (pointer to) another node (corresponding to n2) on the linked list.
    
	// INSERT YOUR CODE HERE
	br lr 
    
////////////////////////
//                    //
//   GetLastNode      //
//                    //
////////////////////////
GetLastNode:
	// input:
	//     x0: The address of (pointer to) a node (corresponding to head) on the linked list.
	// output:
	//     x1: The address of the last node of the linked list.
	
	// INSERT YOUR CODE HERE
	br lr


////////////////////////
//                    //
//    GetNodeWithVal  //
//                    //
////////////////////////
GetNodeWithVal:
	// input:
	//     x0: The address of the node (corresponding to cur) of the input list.
	//     x1: The value (corresponding to val) of the node it’s looking for.
 	// output:
	//     x2: The address of (pointer to) the node with the given value(x1).
	
    // INSERT YOUR CODE HERE
	br lr

    
////////////////////////
//                    //
//     Partition      //
//                    //
////////////////////////
Partition:
	// input:
	//     x0: The address of the first node (corresponding to first) of the linked list.
	//     x1: The value (corresponding to lastVal) of the last node of the linked list.
 	// output:
	//     x2: The address of the first node on the left of the node with the given last node value.

	// INSERT YOUR CODE HERE
	br lr
    

////////////////////////
//                    //
//      QuickSort     //
//                    //
////////////////////////
QuickSort:
	// input:
	//     x0: The address of the first node (corresponding to first) of the list.
	//     x1: The address of the last node (corresponding to last) of the list.
 	// output:
	//     x2: The address of the first node of the list.
	// saved registers:
	//		x19: first, the address of the list's head node
	//		x20: last, the address of the list's tail node
	//		x21: pivot, the return value of partition

	// INSERT YOUR CODE HERE
	// create stack
	SUBI sp, sp, #40 // move sp to allocate stack space
	STUR fp, [sp, #0] // store old fp on top of stack
	STUR lr, [sp, #8] // store old lr below old fp
	ADDI fp, sp, #32 // move old fp to bottom of stack
	
	// save saved registers onto stack
	STUR x19, [fp, #0] // save caller's first onto stack
	STUR x20, [fp, #8] // save caller's last onto stack
	STUR x21, [fp, #16] // save caller's pivot onto stack 
	
	// set new values for first and last based on input
	MOV x19, x0 // 
	MOV x20, x1
	
	// base case comparison (if first == last, then branch to QuickSortReturn)\
	SUBS xzr, x19, x20 // compare first and last
	B.EQ QuickSortReturn // branch if first == last
	
	// call partition(first, last->data)
	// x0 is already address of first node 
	LDUR x1, [x20, #0]// set x1 = last->data
	bl Partition
	
	// set new value for pivot based on return value of partition call
	MOV x21, x2
	
	// if (pivot!=NULL) && pivot->next != NULL, call quicksort on RHS of pivot
	// achieve this by skipping branch to QuickSortRHS if either pivot===NULL or pivot->next == NULL
	cbz x21, SkipQuickSortRHS // pivot == NULL
	LDUR x9, [x21, #8] // save pivot->next into temp register x9
	cbz x9, SkipQuickSortRHS // pivot->next == NULL
	bl QuickSortRHS
	SkipQuickSortRHS:
	
	// if (pivot!=NULL) && first != pivot, call quicksort on LHS of pivot
	// achieve this by skipping branch to QuickSortRHS if either pivot===NULL or first-pivot == 0
	cbz x21, SkipQuickSortLHS // pivot == NULL
	SUBS XZR, x19, x21 // compare first and pivot
	b.eq SkipQuickSortLHS // first-pivot == 0
	bl QuickSortLHS
	SkipQuickSortLHS:
	
	QuickSortReturn:
	// set output (x2) to first (x19)
	MOV x2, x19
	
	// restore saved registers 
	LDUR x19, [fp, #0] // retrieve caller's first from stack
	LDUR x20, [fp, #8] // retrieve caller's last from stack
	LDUR x21, [fp, #16] // retrieve caller's pivot from stack
	
	// restore old fp, lr 
	LDUR fp, [sp, #0] // restore old fp from top of stack
	LDUR lr, [sp, #8] // restore old lr 
	
	// deallocate stack
	ADDI sp, sp, #40 // move sp back to deallocate stack space
	
	// return to caller frame
	br lr 
	
	QuickSortRHS: // QuickSort(pivot->next, last)
		// set x0 to pivot->next
		LDUR x0, [x21, #8]
		// set x1 to last
		MOV x1, x20
		bl QuickSort
		br lr
	
	QuickSortLHS: // QuickSort(first, pivot)
		// set x0 to first
		MOV x0, x19
		// set x1 to pivot
		MOV x1, x21
		bl QuickSort
		br lr

////////////////////////
//                    //
//  QuickSortWrapper  //
//                    //
////////////////////////
QuickSortWrapper:
	// input:
	//     x0: The address of the first node (corresponding to first) of the list.
 	// output:
	//     x1: The address of the first node of the list.
	
    // INSERT YOUR CODE HERE
	br lr 
    
////////////////////////
//                    //
//     printList      //
//                    //
////////////////////////
printList:
    // x0: node address
	addi x3, xzr, #45
	addi x4, xzr, #62
	addi x5, xzr, #88
	addi x6, xzr, #10
printList_loop:
    subis xzr, x0, #0
    b.eq printList_loopEnd
    ldur x1, [x0, #0]
    putint x1
	ldur x0, [x0, #8]
    putchar x3
    putchar x4
    b printList_loop
printList_loopEnd:    
    putchar x5
	putchar x6
    br lr