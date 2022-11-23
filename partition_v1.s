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
	//     x1: The value (corresponding to lastVal) of the last node of the linked list
 	// output:
	//     x2: The address of the first node on the left of the node with the given last node value.
	
	// INSERT YOUR CODE HERE
	// set up stack
	SUBI sp, sp, #48 // create stack frame
	STUR fp, [sp, #0] // store old frame pointer at top of stack
	STUR lr, [sp, #8] //store old link register below old frame pointer
	ADDI fp, sp, #40 // set new frame pointer to bottom of stack

	// initialize various pointers
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
	bl GetNodeWithVal // x2 = getNodeWithVal(first, lastVal)
	bl LoadTemp // load temp register vals
	MOV x10, x2// set x10 (last) to return value of getNodeWithValue
	
	PartitionLoop:
		CBZ x9, PartitionLoopEnd // end loop if cur is NULL
		SUBS x9, x10 // compare cur and first 
		B.EQ PartitionLoopEnd // end loop if cur == last
		// get cur->data for if
		LDUR x19, [x9, #0]  
		// get last->data for if
		LDUR x20, [x10, #0]
		SUBS x19, x20 // if cur->data < last->data
		B.GE EndPartitionIf // ^end if
		MOV x11, x12 // pivot = first
		// swapNodeValue(first, cur)
		MOV x0, x12 // set input arg for swap x0 = first
		MOV x1, x9 // set input arg for swap x1 = cur
		bl SaveTemp // save temp vals
		bl swapNodeValue
		bl LoadTemp // load temp vals
		// visiting the next node
		LDUR x12, [x12, #8] // first = first->next
		EndPartitionIf:
		LDUR x9, [x9, #8] // cur = cur->next

		B PartitionLoop
	PartitionLoopEnd:
	// swapNodeValue(first, last)
	MOV x0, x12 // set input x0 = first for swapNodeVal
	MOV x1, x10// set input x1 = last for swapNodeVal
	bl SaveTemp // save temp register vals
	bl swapNodeVal
	bl LoadTemp // load temp register vals
	MOV x2, x11 // set return value to pivot

	// callee end
	LDUR fp, [sp, #0] // restore old frame pointer
	LDUR lr, [sp, #8] // restore link register
	ADDI sp, sp, #48 // deallocate stack (move sp to old sp location)
	br lr

	// save temp register values to local frame for function calls
	SaveTemp:
		STUR x9, [fp, #0]
		STUR x10, [fp, #-8]
		STUR x11, [fp, #-16]
		STUR x12, [fp, #-24]
		br lr
	// load temp registers from local frame for upon return from function call
	LoadTemp:
		LDUR x9, [fp, #0]
		LDUR x10, [fp, #-8]
		LDUR x11, [fp, #-16]
		LDUR x12, [fp, #-24]
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