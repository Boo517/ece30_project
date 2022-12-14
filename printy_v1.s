////////////////////////
//                    //
// Project Submission //
//                    //
////////////////////////

// Partner1: Noah Dilworth, A15863718
// Partner2: Noe Jimenez, A16281532

////////////////////////
//                    //
//       main         //
//                    //
////////////////////////

    // You can modify main function to test your own test cases.
	// The folloiwng prints unsorted list, call sort function, and print the sorted list again.
    lda x22, list1      // display original list
    MOV x0, x22
    bl printList

	addi x19, xzr, #10  // \n new line
	putchar x19

    MOV x0, x22 // set input for QuickSortWrapper to address of list head
    bl QuickSortWrapper  // return sorted list in x1
	MOV x0, x22	// // set input for printList to address of list head
    bl printList

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
	LDUR	X9, [X0, #0]	// load value at first address
	LDUR	X10, [X1, #0]	// load value at second address
	STUR	X10, [X0, #0]	// store value of second address into first 
	STUR	X9, [X1, #0]	// store value at first address into second
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

		CBZ	X0, basecase		// Check if first address is NULL
		LDUR X9, [X0, #8]	// Load next address into temp 
		CBZ	X9, basecase		// Check to see if next address is NULL 
		MOV	X0, X9		// set x0 to current node's next
		B	GetLastNode	// Return to top of getlast and repeat 	

	basecase:
		ADD	X1, XZR, X0	// return address of last node
		br lr

////////////////////////
//                    //
//    GetNodeWithVal  //
//                    //
////////////////////////
GetNodeWithVal:
	// input:
	//     x0: The address of the node (corresponding to cur) of the input list.
	//     x1: The value (corresponding to val) of the node it???s looking for.
 	// output:
	//     x2: The address of (pointer to) the node with the given value(x1).
	
    // INSERT YOUR CODE HERE

	// build stack
	SUBI sp, sp, #16 // two 8-byte chunks, for old fp and lr
	STUR fp, [sp, #0] // store old fp at top of stack
	STUR lr, [sp, #8] // store old lr below old fp, at bottom of stack
	ADDI fp, sp, #8 // assign fp to bottom of stack
	
	// set return value to default (cur=x0) for ease of program flow
	MOV x2, x0
	
	// check cur==NULL, if so branch to return, w/ default x2=cur 
	CBZ x0, GetNodeWithValReturn
	
	// check cur->data==val, if so branch to return, w/ default x2=cur 
	LDUR x9, [x0, #0] // save cur->data into a temp register (x9) for branch condition
	CMP x9, x1 // compare cur->data (x9) and val (x1)
	b.eq GetNodeWithValReturn // branch to return if condition holds
	
	// if neither condition true, make recursive call
	// set new input for cur, no need to do anything for val as it remains the same
	LDUR x0, [x0, #8] // cur = cur->next
	bl GetNodeWithVal // recursive call on rest of list
	
	GetNodeWithValReturn:
	// retrieve old fp, lr
	LDUR fp, [sp, #0] 
	LDUR lr, [sp, #8]
	
	// deallocate stack (16 bytes for old fp, lr)
	ADDI sp, sp, #16 
	
	// return to caller line
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
	
	// set up stack
	SUBI sp, sp, #48 // create stack frame
	STUR fp, [sp, #0] // store old frame pointer at top of stack
	STUR lr, [sp, #8] //store old link register below old frame pointer
	ADDI fp, sp, #40 // set new frame pointer to bottom of stack

	// initialize various addresses in caller-saved temp registers, needed for partition
	// the procedures SaveTemp and LoadTemp handle saving and retrieving them from the stack
	//	x9: cur (the address of the node whose val we compare to lastVal)
	//	x10: last (address of the node which contains lastVal)
	//	x11: pivot (what we're gonna return eventually)	
	//	x12: first 
	
	MOV x12, x0 // set first to input arg
	MOV x11, x12 // pivot = first
	MOV x9, x12 // cur = first
	
	// set up stack to call getNodeWithVal
	// x0 is already first
	// x1 is already lastVal
	bl SaveTemp // save temp register vals
	bl GetNodeWithVal // call GetNodeWithVal to get the address of lastVal, to be saved in x10 (last)
	bl LoadTemp // load temp register vals
	MOV x10, x2 // set x10 (last) to return value of getNodeWithValue
	
	PartitionLoop:
		// end loop if cur is NULL
		CBZ x9, PartitionLoopEnd // end loop
		
		// end loop if cur == last
		SUBS xzr, x9, x10 // compare cur and last 
		B.EQ PartitionLoopEnd // end loop
		
		// if cur->data < last->data, then swap values of first and cur and update pivot
		LDUR x13, [x9, #0]  // get cur->data for if
		LDUR x14, [x10, #0] // get last->data for if
		CMP x13, x14  // compare cur->data and last->data
		B.GE EndPartitionIf // bypass if cur->data >= last->data (inverse statement)
		MOV x11, x12 // pivot = first
		
		// swapNodeValue(first, cur)
		MOV x0, x12 // set input arg for swap x0 = first
		MOV x1, x9 // set input arg for swap x1 = cur
		bl SaveTemp // save temp vals
		bl SwapNodeValue
		bl LoadTemp // load temp vals
		
		// visiting the next node
		LDUR x12, [x12, #8] // first = first->next
		
		EndPartitionIf:
		LDUR x9, [x9, #8] // cur = cur->next

		B PartitionLoop
	PartitionLoopEnd:
	// swapNodeValue(first, last)
	MOV x0, x12 // set input x0 = first for swapNodeVal
	MOV x1, x10 // set input x1 = last for swapNodeVal
	bl SaveTemp // save temp register vals
	bl SwapNodeValue
	bl LoadTemp // load temp register vals
	MOV x2, x11 // set return value to pivot

	// callee end
	LDUR fp, [sp, #0] // restore old frame pointer
	LDUR lr, [sp, #8] // restore link register
	ADDI sp, sp, #48 // deallocate stack (move sp to old sp location)
	br lr

	// save temp register values to local frame for function calls
	SaveTemp:
		STUR x9, [fp, #0] // cur
		STUR x10, [fp, #-8] // last
		STUR x11, [fp, #-16] // pivot
		STUR x12, [fp, #-24] // first
		br lr
	// load temp registers from local frame for upon return from function call
	LoadTemp:
		LDUR x9, [fp, #0] // cur
		LDUR x10, [fp, #-8] // last
		LDUR x11, [fp, #-16] // pivot
		LDUR x12, [fp, #-24] // first
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

	// INSERT YOUR CODE HERE
	// create stack
	SUBI sp, sp, #40 // move sp to allocate stack space
	STUR fp, [sp, #0] // store old fp on top of stack
	STUR lr, [sp, #8] // store old lr below old fp
	ADDI fp, sp, #32 // move old fp to bottom of stack
	
	// save saved registers onto stack
	STUR x19, [fp, #0] // save caller's first onto stack
	STUR x20, [fp, #-8] // save caller's last onto stack
	STUR x21, [fp, #-16] // save caller's pivot onto stack 
	
	// set new values for first and last based on input
	MOV x19, x0
	MOV x20, x1
	
	// base case comparison (if first == last, then branch to QuickSortReturn)
	SUBS xzr, x19, x20 // compare first and last
	B.EQ QuickSortReturn // branch if first == last
	
	// call partition(first, last->data)
	MOV x0, x19 // set x0 = address of first node
	LDUR x1, [x20, #0] // set x1 = last->data
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
	// achieve this by skipping branch to QuickSortRHS if either pivot==NULL or first==pivot
	cbz x21, QuickSortReturn // pivot == NULL
	SUBS XZR, x19, x21 // compare first and pivot
	b.eq QuickSortReturn // first==pivot
	bl QuickSortLHS
	
	QuickSortReturn:
	// set output (x2) to first (x19)
	MOV x2, x19
	
	// restore saved registers 
	LDUR x19, [fp, #0] // retrieve caller's first from stack
	LDUR x20, [fp, #-8] // retrieve caller's last from stack
	LDUR x21, [fp, #-16] // retrieve caller's pivot from stack
	
	// restore old fp, lr 
	LDUR fp, [sp, #0] // restore old fp from top of stack
	LDUR lr, [sp, #8] // restore old lr 
	
	// deallocate stack
	ADDI sp, sp, #40 // move sp back to deallocate stack space
	
	// return to caller frame
	br lr 
	
	QuickSortRHS: // QuickSort(pivot->next, last)
		// set up stack
		SUBI sp, sp, #16 // space for old fp, lr
		STUR fp, [sp, #0] // store old fp on top of stack
		STUR lr, [sp, #8] // store old lr
		ADDI fp, sp, #8 // move fp to bottom of stack
		
		// call quicksort on RHS of pivot (inclusive)
		LDUR x0, [x21, #8] // set x0 to pivot->next
		MOV x1, x20 // set x1 to last
		bl QuickSort
		
		// restore old fp, lr
		LDUR fp, [sp, #0] // restore old fp from top of stack
		LDUR lr, [sp, #8] // restore old lr
		
		// deallocate stack		
		ADDI sp, sp, #16
		
		br lr // return to quicksort main
	
	QuickSortLHS: // QuickSort(first, pivot)
		// set up stack
		SUBI sp, sp, #16 // space for old fp, lr
		STUR fp, [sp, #0] // store old fp on top of stack
		STUR lr, [sp, #8] // store old lr
		ADDI fp, sp, #8 // move fp to bottom of stack
		
		// call quicksort on LHS of pivot (exclusive)
		MOV x0, x19 // set x0 to first
		MOV x1, x21 // set x1 to pivot
		MOV x23, lr // save lr back to quicksort in saved register x23
		bl QuickSort
		
		// restore old fp, lr
		LDUR fp, [sp, #0] // restore old fp from top of stack
		LDUR lr, [sp, #8] // restore old lr
		
		// deallocate stack		
		ADDI sp, sp, #16
		
		br lr // return to quicksort main

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
	// set up stack
	SUBI sp, sp, #32 // 
	STUR fp, [sp, #0] // store old fp at top of stack
	STUR lr, [sp, #8] // store old lr below old fp
	STUR x0, [sp, #16] // store address of first node, needed for quicksort
	
	// call GetLastNode(first) to get the last node of the list to call quicksort with
	bl GetLastNode // x0 is already the address of the first node
	
	// call QuickSort
	LDUR x0, [sp, #16] // set x0 to address of first node for quicksort
	bl QuickSort // x1 is already address of last node, as it was the return value of GetLastNode
	
	// set output (x1) to output of QuickSort (x2)
	MOV x1, x2
	
	// restore old fp, lr
	LDUR fp, [sp, #0] 
	LDUR lr, [sp, #8]
	
	// deallocate stack
	ADDI sp, sp, #32
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