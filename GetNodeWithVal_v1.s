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
    
	ADDI x1, x1, #96  // set input x1 to 96
	bl getNodeWithVal // call getNodeWithVal on x0 with val=x1(96)
	LDUR x9, [x2, #8] // get value of node at address x2 to check if it's 96 (found correct node), and store it in temp register x9
    putint x9 		  // print output.value

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
	//     x2: The address of (pointer to) the node with the given value(=x1).
	
    // INSERT YOUR CODE HERE
	
	// build stack
	SUBI sp, [sp, #16] // two 8-byte chunks, for old fp and lr
	STUR fp, [sp, #0] // store old fp at top of stack
	STUR lr, [sp, #8] // store old lr below old fp, at bottom of stack
	ADDI fp, sp, #8
	
	// set return value to default (cur=x0) for ease of program flow
	MOV x2, x0
	
	// check cur==NULL, if so branch to return, w/ default x2=cur 
	CBZ x0, GetNodeWithValReturn
	
	// check cur->data==NULL, if so branch to return, w/ default x2=cur 
	LDUR x9, [x0, #0] // save cur->data into a temp register (x9) for branch condition
	CBZ x9, GetNodeWithValReturn
	
	// if neither condition true, make recursive call
	// set new input for cur, no need to do anything for val as it remains the same
	LDUR x0, [x0, #8] // cur = cur->next
	bl GetNodeWithVal
	
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