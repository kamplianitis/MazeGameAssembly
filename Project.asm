.data

.globl map
.globl temp
.globl W
.globl H
.globl PlayerPos

.globl total

W: .word 21
H: .word 11
total: .word 231

PlayerPos: .word 1
	
temp: .space 100
	
##################################################
#strings

Labyrinth : .asciiz "\nLabyrinth: \n"
enter: .asciiz "\n"			
map: .asciiz "I.IIIIIIIIIIIIIIIIIIII....I....I.......I.IIII.IIIII.I.I.III.I.II.I.....I..I..I.....II.I.III.II...II.I.IIII...I...III.I...I...IIIIII.IIIII.III.III.II.............I.I...IIIIIIIIIIIIIIII.I.III@...............I..IIIIIIIIIIIIIIIIIIIIIII"
       	     
wincase: .asciiz "\nWinner Winner Chicken Dinner"
positionchange: .asciiz "\nWhere you wanna go? "
a : .asciiz "a"
notvalid: .asciiz "\nnot valid call\n"

I: .asciiz "I"


.text 


	.globl main
	
	
	
	
		main:
			jal printLabyrinth
			jal findPath
			
			li $v0, 10
			syscall
	
		
	#--------------------------------------------------------------------------------------------------------------#			
	printLabyrinth:
	# load the adress of the temp array so that we can do what the statement asks
	la $t3, temp # stores in the register t3 the address of the first element of the temp array
	la $t4, map  # same as here
	
	#now we print the labyrinth
	li $v0, 4
	la $a0, Labyrinth
	syscall
	
	
	
	li $t0, 0 # initiate the i counter
	li $t2, 0 # inititate the k counter
	lw $s0, H #load the H from the data segment to use it for comparison 
	
	#statement
	whilelabel1:
	beq $t0, $s0 , end1 # for 1
	
	lw $s1, W # load the W from the data segment to use it for comparison
	li $t1, 0 # initiation of the j counter
	
	whilelabel2: #second for (nested)
	beq $t1, $s1, end2
	
	# we load playerPos to use it in the if statement
	lw $s2, PlayerPos
	
	# now we write the if statement
	bne $t2, $s2, elselabel
	la $t3, temp # we reset the t3 register to show again on the right spot(first element) so we can move to the right position 
	#now i have to find the temp[playerPos] and make this position P instead of '.'
	add $t3, $t3, $t1 # we go to the address that the temp[j] exists
	# we put the letter P in a register so we can use it right after to store it in the temp array
	li $t5, 0
	add $t5, $t5, 80 
	
	
	sb $t5, 0($t3) # we make the P (in ascii code) to the adress that is currently in the t3 register
	
	j afteriflabel
	
	elselabel:
	# we reset the t3 and t4 registers so they dont take other values than the expected ones.
	la $t3, temp
	la $t4, map
	add $t3, $t3, $t1 #make the address of t3 register, the access of the element we want to have
	add $t4, $t4, $t2 #same for the map so we can do the processing after
	lb $t4, 0($t4) # we take the whole element of the specific address so we can store it right after in the temp array
	# now the only thing we have to do is store the 
	sb $t4, 0($t3) # stores the whole element in the address of the temp array
	
	afteriflabel:
	# what we have to do in that function is to increase the counter's values (k, j)
	addi $t2, $t2, 1 #k increases by one
	addi $t1, $t1, 1 # j increases by one
	j whilelabel2
	
	end2:
	# now we print the temp we have created ... because of the asciiz on the string we dont need to create another element to put the 0 in it in the temp so we are ok 
	li $v0, 4
	la $a0, temp
	syscall
	# in the end we want to press enter so the next line prints in the lane right above
	li $v0, 4
	la $a0, enter
	syscall
	
	addi $t0, $t0, 1 # we increase i's value
	
	j whilelabel1 # we do this again and again util the statement above is fullfilled		
	
	end1:
	jr $ra # return 
	
	#----------------------------------------------------------------------------------------------#
	
	
	makeMove:
		
	# in this function there is a need for stack so we put all the return adresses. We create a stack that in the first element there is the 
	addi $sp, $sp, -8
	sw $ra, ($sp)
	sw $s0, 4($sp)
	
	lw $s0, PlayerPos
	lw $s1, total
	#we dont have the ability to have two statements simultaneously so we write the one after the other
	bgez $s0, notreturn0label
	blt $s0, $s1, notreturn0label
	
	#when the process returns 0 the ra of the final makemove will return to the 2nd final make move ect
	return0:
	li $v0, 0 # so that the process returns to 0
	lw $s0, 4($sp) #return the playerpos of the 2nd final make move
	lw $ra, 0($sp) #returns the ra that is in the first block of the stack 
	addi $sp, $sp, 8 # deletes the list
	jr $ra
	
	notreturn0label:
	#we need to load the map again and see the element inside
	la, $t1, map
	add $t1, $t1, $s0 # move to the right position of the map
	
	#now we have to compare it with the dot. so we use a register to put the dot (ascii code) inside and make the comparison
	li $t2, 0 #initiation so the ascii code can be stored
	add $t2, $t2, 46 # 46 is the ascii code for the dot
	
	#create the opossite statement compared to c
	bne $t1, $t2 elseiflabel
	
	# we reset the map again and then it is time to put the * in the map[playerpos]
	la $t1, map
	add $t1, $t1, $s0 # now we are at the map[playerPos]
	
	
	#we create the * in ascii code
	li $t4, 0 # we initiate the t4 to put the star in there
	add $t4, $t4, 42 # ascii code for the star
	
	sb $t4, 0($t1)
	
	jal printLabyrinth #prints the labyrinth with the * in the playerpos instead of a dot
	
	addi $s0, $s0, 1 # we move the playerPos so the character can go rigth
	jal makeMove
	
	beq $v0, $zero,  upwards
	
	li $t5, 0 
	add $t5, $t5, 35
	
	la $t1, map 
	add $t1, $t1, $s0
	sb $t5, 0($t1)
	jal printLabyrinth
	li $v0, 1 # sends the v0 back 
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8 # resets the sp to the previous position
	jr $ra
	
	upwards:
	lw $t7, W
	
	sub $s0, $s0, $t7 # we move the playerPos so the character can go rigth
	jal makeMove
	
	beq $v0, $zero, downwards
	li $t5, 0 
	add $t5, $t5, 35
	
	la $t1, map 
	add $t1, $t1, $s0
	sb $t5, 0($t1)
	jal printLabyrinth
	li $v0, 1 # sends the v0 back 
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8 # resets the sp to the previous position
	jr $ra
	
	downwards:
	lw $t7, W
	
	add $s0, $s0, $t7 # we move the playerPos so the character can go rigth
	jal makeMove
	
	beq $v0, $zero, left
	li $t5, 0 
	add $t5, $t5, 35
	
	la $t1, map 
	add $t1, $t1, $s0
	sb $t5, 0($t1)
	jal printLabyrinth
	li $v0, 1 # sends the v0 back 
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8 # resets the sp to the previous position
	jr $ra
	
	left:
	li $t7, -1
	
	add $s0, $s0, $t7  # we move the playerPos so the character can go rigth
	jal makeMove
	
	beq $v0, $zero,  right # case the return is 0 so we can go to the next condition
	li $t5, 0 
	add $t5, $t5, 35
	
	la $t1, map 
	add $t1, $t1, $s0
	sb $t5, 0($t1)
	jal printLabyrinth
	li $v0, 1 # sends the v0 back 
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8 # resets the sp to the previous position
	jr $ra
	
	right:
	addi $s0, $s0, 1 # we move the playerPos so the character can go rigth
	jal makeMove
	
	beq $v0, $zero return0
	li $t5, 0 
	add $t5, $t5, 35
	
	la $t1, map 
	add $t1, $t1, $s0
	sb $t5, 0($t1)
	jal printLabyrinth
	li $v0, 1 # sends the v0 back 
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8 # resets the sp to the previous position
	jr $ra
	
	
	
	elseiflabel: # case the playerpos element is in the @
	li $v0, 10
	syscall
	
	#-------------------------------------------------------------------------------------------#
	
	

	findPath:
	
	 # we break the while in two if statements that happen one after another
	 
	 #first we check that the map[playerpos] is not at the @ 
	 
	 while:
	 # we load the map and the playerPos to find the specific location of the map
	 la $t3, map
	 la $t2, PlayerPos
	 add $t3, $t2, $t3 # we do this to go to the playerPos element of the map 
	 # now we have to load the playerPos element of the map
	 
	 # now we make the @ trough ascii
	 li $t1, 0
	 add $t1, $t1, 64
	 
	 # first statement
	 beq $t3, $t1, endloop
	 
	 li $v0, 4
	 la $a0, positionchange
	 syscall
	 
	polling:
	li $s1, 0xffff0000
	li $s2, 0xffff0004
	
	
	andi $s1, $s1, 1
	beq $s1, $zero, polling
	lw $v0, 0($s2) 
	 
	 move $t5, $v0
	 # we move the char to a $t5 register and  we create the e to go to the end loop
	 
	 li $t6, 0 # char initiation
	 add $t6, $t6, 101 # e char with ascii
	 
	#now we create all the possible letters with ascii code to  
	 li $t4, 0 #creation of the w
	 add $t4, $t4, 119
	 
	 li $t7, 0 #creation of the s
	 add $t7, $t7, 115
	 
	 li $t8, 0 # creation of the a
	 add $t8, $t8, 97
	 
	 li $t9, 0 # creation of the d
	 add $t9, $t9, 100
	 
	 
	 beq $t5, $t6, endloop
	 beq $t5, $t4 casew
	 beq $t5, $t7 cases
	 beq $t5, $t8 casea
	 beq $t5, $t9 cased
	 
	 li $v0, 4
	 la $a0, notvalid
	 syscall
	 
	 j while
	 
	 # now we build the cases
	 
	 casew:
	 la $t3, map # take the map and put it into a register
	 lw $s1, PlayerPos
	 la $s2, 0 # char initiation
	 add $s2, $s2, 46
	 la $s3, 0
	 li $s3, 64
	 
	 addi $s1, $s1, -21 # make the playerPos-W
	 
	 
	 add $t3, $s1, $t3 # now we are at the playerPos-W element
	 lb $t3, 0($t3)
	 
	 beq $t3, $s3 ,winnercasew
	 bne $t3, $s2 ,notvalidmovew
	 sb $s1, PlayerPos
	 jal printLabyrinth
	 j while
	 
	 notvalidmovew:
	 li $v0, 4
	 la $a0, notvalid
	 syscall
	 j while
	 
	 winnercasew:
	 li $v0, 4
	 la $a0, wincase
	 syscall
	 li $v0, 10
	 syscall
	 
	 cases:
	 la $t3, map # take the map and put it into a register
	 lw $s1, PlayerPos
	 la $s2, 0 # char initiation
	 add $s2, $s2, 46
	 la $s3, 0
	 li $s3, 64
	 
	 addi $s1, $s1, 21 # make the playerPos+W
	 
	 
	 add $t3, $s1, $t3 # now we are at the playerPos+W element
	 lb $t3, 0($t3)
	 
	 beq $t3, $s3, winnercases
	 bne $t3, $s2 ,notvalidmoves
	 sb $s1, PlayerPos
	 jal printLabyrinth
	 j while
	 
	 notvalidmoves:
	 li $v0, 4
	 la $a0, notvalid
	 syscall
	 j while
	 
	 winnercases:
	 li $v0, 4
	 la $a0, wincase
	 syscall
	 li $v0, 10
	 syscall
	 
	 casea:
	 la $t3, map # take the map and put it into a register
	 lw $s1, PlayerPos
	 la $s2, 0 # char initiation
	 add $s2, $s2, 46
	 la $s3, 0
	 li $s3, 64
	 
	 addi $s1, $s1, -1 # make the playerPos-1
	 
	 
	 add $t3, $s1, $t3 # now we are at the playerPos-1 element
	 lb $t3, 0($t3)
	 
	 beq $t3, $s3 ,winnercasea
	 bne $t3, $s2, notvalidmovea
	 sb $s1, PlayerPos
	 jal printLabyrinth
	 j while
	 
	 notvalidmovea:
	 li $v0, 4
	 la $a0, notvalid
	 syscall
	 j while
	 
	 winnercasea:
	 li $v0, 4
	 la $a0, wincase
	 syscall
	 li $v0, 10
	 syscall
	 
	 cased:
 	 la $t3, map # take the map and put it into a register
	 lw $s1, PlayerPos
	 la $s2, 0 # char initiation
	 add $s2, $s2, 46
	 la $s3, 0
	 li $s3, 64
	 
	 addi $s1, $s1, +1 # make the playerPos+1
	 
	 
	 add $t3, $s1, $t3 # now we are at the playerPos+1 element
	 lb $t3, 0($t3)
	 
	 beq $t3, $s3,winnercased
	 bne $t3, $s2, notvalidmoved
	 sb $s1, PlayerPos
	 jal printLabyrinth
	 j while
	 
	 notvalidmoved:
	 li $v0, 4
	 la $a0, notvalid
	 syscall
	 j while
	 
	 winnercased:
	 li $v0, 4
	 la $a0, wincase
	 syscall
	 li $v0, 10
	 syscall
	 
	 endloop:
	 jr $ra


	
	
	

