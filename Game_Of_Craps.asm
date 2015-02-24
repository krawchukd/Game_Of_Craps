## David Krawchuk
## 11/4/2013
## Program: Craps
##
## This program simulates the game of Craps :
## Here is the basic setup:
## 1. The game involves two dice. Each die has six faces. These faces contain 1, 2, 3, 4, 5 and 6 spots, respectively.
## 2. The player plays against the "house", rather than against another player.
## 3. Note that the first throw of the dice is handled differently than subsequent throws.
## Here is how the game is played:
## 1. The player rolls two dice.
## 2. After the dice have come to rest, the player adds the spots on the two upward faces to
## get their sum.
## 3. If the sum is 7 or 11 on the first throw, the player wins.
## 4. If the sum is 2, 3 or 12 on the first throw (these three values are called "craps"), the
## player loses (i.e., the "house" wins).
## 5. If the sum is 4, 5, 6, 8, 9 or 10 on the first throw, this special number becomes the
## player's "point".
## 6. To win, the player must continue rolling the dice until he/she "makes his/her point" (i.e.,
## rolls the special point value again).
## 7. The player loses by rolling a 7 before making the point.
##
## Note : Convention followed for working with stack is as follows: 
##		Caller stores needed values on stack and restores needed values back upon return from function block.
##		Callee has no responsibilities to registers.
##
##

.data
## Statement Strings ##
heading:
	.asciiz "Welcome to the Game of Craps!\n"	

die_Roll_Statement:
	.asciiz "The dice roll is:\t"
	
space:
	.asciiz " "
	
win_Statement:
	.asciiz "You have won.\n"

loss_Statement:
	.asciiz "You have lost.\n"
	
point_Statement:
	.asciiz "The point is:\t"

print_RollDie_Prompt:
	.asciiz "Press ENTER to roll the dice:\n"
	
## END Statement Strings ##

##
##

## Function Block ##

.text
# Function prints prompt.
printHeading:

	li $v0, 4                               # Load system call code 4 into register $v0; System call code 4 represents print_string.
	la $a0, heading                         # Load address of string to print.
	syscall                                 # Perform system call.
	
	jr $ra                                  # Return to caller.
	
end_PrintHeading:

# Function to prompt user to roll dice. Reads in a character; used to wait for user input.
promptToRoll:
	
	li $v0, 4                               # Load system call code 4 into register $v0; System call code 4 represents print_string.
	la $a0, print_RollDie_Prompt            # Load address of string to print.
	syscall                                 # Perform system call.
	
	# Note read character is wasted!
	li $v0, 12                              # Read in character.
	syscall                                 # Perform syscall.

	jr $ra                                  # Return to caller.
	
end_PromptToRoll:

# Function returns a random value in the range of 1-6. Returns value in register $v0.
rollDie:
	
	# Note: system call code 42 returns values to register $a0 by default. Therefore the result must be 
	# 	moved to register $v0 for return.
	li $a0, 0                               # Set lower range.
	li $a1, 6                               # Set upper range.
	li $v0, 42                              # Set system call dode to 42; code 42 represents random int range.
	syscall                                 # Perform syscall.
	
	addi $a0, $a0, 1                        # Add 1 to returned argument to correct returned range.
	move $v0, $a0                           # Move return value into function return register.
	
	jr $ra                                  # Return to caller.
	
end_RollDie:

# Function takes no parameters, and returns two arguments in $v0, $v1.
rollPairOfDie:

	# Push register $ra onto the stack.
	sub $sp, $sp, 4                       	# Adjust stack to make room for the return address in register $ra.
	sw $ra, 0($sp)                          # Push caller return address onto the stack.
	
	# Roll first die.
	jal rollDie                             # Perform function; return value in register $v0.
	move $s0, $v0                           # Moved returned argument to register $s0.

   	sub $sp, $sp, 4  			# Adjust stack to make room for the value of die 1.
   	sw $s0, 0($sp)				# Push die roll one onto the stack.

	# Roll second die.
	jal rollDie				# Perform function; returned value in register $a0.

    	lw $v1, 0($sp)				# Copy roll one from the stack to the return register $v1. 
    						# Register $v0 contains roll 2. Order is not important. 
    	add $sp, $sp, 4				# Pop one value off stack.

	# Reload original $ra address from stack.
	lw $ra, 0($sp)				# Load caller's return address back into register $ra.
	add $sp, $sp, 4 			# Push one value (word) off stack.

    	jr $ra					# Return to caller; with random values returned in registers $v0, $v1.
	
end_RollPairOfDie:

# Function takes two dice values as parameters, and prints their values on a single line, with appropriate 
# text preceding it.
printPair:
	
	move $t0, $a0				# Move argument register $a0 to temp register $t0.
	move $t1, $a1				# Move argument register $a1 to temp register $t1.
	
	li $v0, 4                       	# Load system call code 4 into register $v0; System call code 4 represents print_string.
	la $a0, die_Roll_Statement      	# Load address of string to print.
	syscall					# Perform system call.
	
	li $v0, 1                       	# Load system call code 1 into register $v0; System call code 1 represents print_int.
	la $a0, 0($t0)                  	# Load argument 1 into register $a0 for syscall
	syscall					# Perform system call.
	
	li $v0, 4                       	# Load system call code 4 into register $v0; System call code 4 represents print_string.
	la $a0, space                   	# Load address of space to print a space.
	syscall					# Perform system call.
	
	li $v0, 1                       	# Load system call code 1 into register $v0; System call code 1 represents print_int.
	la $a0, 0($t1)                  	# Load argument 1 into register $a0 for syscall
	syscall					# Perform system call.
	
	li $v0, 11                      	# Load system call code 11 into register $v0; System call code 11 represents print_char.
	li $a0, '\n'                    	# Load newline character into register $a0. Perform carage return.
	syscall					# Perform system call.
	
	jr $ra					# Return to caller.
	
end_PrintPair:

# Takes the values of the roll of two dice as its parameters. If the sum of the parameter is 7 or 11 it should 
# print a message saying the player has won and exit the program. If the sum of the parameters is 2, 3, or 12 it 
# should print a message saying the player has lost and exit the program. Otherwise it should return.
firstRoll:

add $t0, $a0, $a1				# Sum the arguments into temp register.

# Store currently used variables on stack.
sub $sp, $sp, 16				# Move stack pointer down 16 bytes to make room for $ra, two arguments, and sum..
sw $ra, 12($sp)					# Store contents of $ra into first open word.
sw $t0, 8($sp)      				# Store contents of $t0(sum) into next open word.
sw $a1, 4($sp)      				# Store contents of $a0(roll 1)into next open word.
sw $a0, 0($sp)     				# Store contents of $a1(roll 2) into next open word.

## IF ##
beq $t0, 7, printWin	 			# Break to label if $t0(sum) is equal to 7.
beq $t0, 11, printWin 	 			# Break to label if $t0(sum) is equal to 11.
## End IF ##

## ELSE IF ##
beq $t0, 2, printLoss	 			# Brak to label if $t0(sum) is equal to 2.
beq $t0, 3, printLoss	 			# Brak to label if $t0(sum) is equal to 3.
beq $t0, 12 printLoss			 	# Brak to label if $t0(sum) is equal to 12.
## End ELSE IF  ##

## ELSE ##
# Perform printPair function block; restore values upon function return.
jal printPair					# Print die values.

# Restore registers. (As per convention.)
lw $a0, 0($sp)					# Restore argument register $a0.
lw $a1, 4($sp)					# Restore argument register $a1.
lw $t0, 8($sp)					# Restore sum into temp register $t0.

# Move sum to argument register $a0.
move $a0, $t0        				# Move sum $t0 into argument register $a0.
jal printPoint					# Print point value.

# Restore registers to function; to original state before printPair function block call.(As per convention)
lw $a0, 0($sp)					# Restore argument register $a0 to pre function state.
lw $a1, 4($sp)					# Restore argument register $a1 to pre function state.
lw $t0, 8($sp)					# Restore temp register $t0(sum) to pre function state.
lw $ra, 12($sp)					# Restore return address to $ra retister to pre function state.
addi $sp, $sp, 16				# Pop 4 items (words) off the stack.

jr $ra 						# Return to caller.
## END ELSE ##

# printWin block prints pair values, point, win statement, then ends program. Note: no need to restore registers due to unconditional jump to endGame link.
printWin:

# Print pair and print point.
jal printPair               			# Print output before printing win_Statement.
lw $a0, 8($sp)					# Load sum value into argument register $a0.
jal printPoint              			# Print point value.

li $v0, 4                   			# Load system call code 4 into register $v0; System call code 4 represents print_string.
la $a0, win_Statement       			# Load address of string to print.
syscall                     			# Perform system call.

j endGame                  			# Unconditional jump to endGame.
EndPrintWin:

# printLoss block prints pair values, point, loss statement, then ends program. Note: no need to resotre registers due to unconditional jump to endGame link.
printLoss:

jal printPair               			# Print output before printing loss_Statement.
lw $a0, 8($sp)
jal printPoint              			# Print point value.

li $v0, 4                   			# Load system call code 4 into register $v0; System call code 4 represents print_string.
la $a0, loss_Statement      			# Load address of string to print.
syscall                     			# Perform system call.

j endGame                   			# Unconditional jump to endGame.
EndPrintLoss:

end_FirstRoll:

# Function takes the current point as its parameter and prints it, preceded by an appropriate message.
printPoint:

move $t0, $a0 					# Move argument to temp register $t0.

li $v0, 4					# Load system call code 4 into register $v0; System call code 4 represents print_string.
la $a0, point_Statement				# Load address of string to print.
syscall						# Perform system call.

li $v0, 1					# Load system call code 1 into register $v0; System call code 1 represents print_int.
move $a0, $t0					# Move contents of $t0 into argument register $a0.
syscall						# Perform system call.

li $v0, 11					# Load system call code 11 into register $v0; System call code 11 represents print_char.
li $a0, '\n'					# Load newline character into argument register $a0; returns carrage to newline.
syscall						# Perform system call.

jr $ra						# Return to caller.

endPrintPoint:

# Function takes three parameters, the value of each die, and the current point. If the sum of the dice is equal 
# to the point, it should print a message saying the player has won, and exit the program. If the sum of the dice 
# is 7, it should print a message saying the player has lost and exit the program. Otherwise it should return.
checkPoint:

add $t0, $a0, $a1				# Sum first two arguments.
## IF (sum == point($a2)) ##
beq $t0, $a2, printPlayerWon			# If temp sum is equal to current point value, break to printPlayerWon label.
## END IF ##

## ELSE IF (sum == 7) ##
beq $t0, 7, printPlayerLoss			# If temp sum is equal to the integer value 7, break to printPlayerLoss label.
## END ELSE IF ##

## ELSE return to caller. ##
jr $ra						# If all other conditions fail, return to calling address.
## END ELSE ##

end_CheckPoint:

# Player won block. Prints statement and ends game.
printPlayerWon:

li $v0, 4					# Load system call code 4 into register $v0; System call code 4 represents print_string.
la $a0, win_Statement				# Load address of string to print.
syscall						# Perform system call.

j endGame					# Unconditional jump to endGame.

end_PrintPlayerWon:

# Player loss block. Prints statement and ends game.
printPlayerLoss:

li $v0, 4					# Load system call code 4 into register $v0; System call code 4 represents print_string.
la $a0, loss_Statement				# Load address of string to print.
syscall						# Perform system call.

j endGame					# Unconditional jump to endGame.

end_PrintPlayerLoss:

endCheckPoint:

.globl main
main:

## Do ##
jal printHeading 				# Print heading.
jal promptToRoll				# Prompt user to press ENTER to roll.

# Roll die and store returned values in stack.
jal rollPairOfDie				# Roll Die.

move $s0, $v0           			# Move values from returned register to saved register(by convention).
move $s1, $v1           			# Move values from returned register to saved register(by convention).

add $s2, $s0, $s1           			# Create point value.
	
sub $sp, $sp, 12		 		# Create space for 12 bytes: two die, one sum.
sw $s2, 8($sp)			 		# Push sum into next open stack location.
sw $s0, 4($sp)			 		# Push first roll into next open stack location.
sw $s1, 0($sp)			 		# Push second roll into first open stack location.

lw $a0, 4($sp)					# Load argument $a0 with roll 1.
lw $a1, 0($sp)					# Load argument $a1 with roll 2.

jal firstRoll					# Perform firstRoll function block.

lw $s2, 8($sp)					# Restore point value to $s2 register.
lw $s0, 4($sp)					# Restore roll 1 value to $s0 register.
lw $s1, 0($sp)					# Restore roll 2 value to $s1 register.
add $sp, $sp, 12				# Pop 3 items or words off stack.
## END DO ##

## WHILE ##
rollLoop:

jal promptToRoll				# Prompt user to roll.

sub $sp, $sp, 4					# Create space on stack for point value.
sw $s2, 0($sp)		 			# Push point value on stack.

jal rollPairOfDie       			# Perform Roll die function block.

lw $s2, 0($sp)					# Restore point value to $s2.
add $sp, $sp, 4					# Pop value off stack.

# Move returned values into s registers.
move $s0, $v0           			# Move values from returned register to saved register(by convention).
move $s1, $v1           			# Move values from returned register to saved register(by convention).

sub $sp, $sp, 12				# Create space for three values on stack.

# Store used registers before function block call.
sw $s0, 8($sp)					# Push point value onto stack.
sw $s0, 4($sp)          			# Push returned roll one onto stack.
sw $s1, 0($sp)          			# Push returned roll two onto stack.

# Move die values to argument registers, then call printPair function.
move $a0, $s0					# Copy roll 1 into argument register $a0.
move $a1, $s1					# Copy roll 2 into argument register $a1.
jal printPair           			# Print value of rolled die.

# Load values back into registers from stack.
lw $s0, 0($sp)          			# Restore roll one to register $s0.
lw $s1, 4($sp)       				# Restore roll two to register $s1.
lw $s1, 8($sp)					# Restore point value to register $s2.

add $sp, $sp, 12				# Pop three values off stack.

move $a0, $s0					# Copy roll 1 into argument register $a0.
move $a1, $s1					# Copy roll 2 into argument register $a1.
move $a2, $s2					# Copy point value into argument register $a2.

jal checkPoint          			# Check current rolls to current point value.

j rollLoop					# Return to begining of roolLoop block.

endRollLoop:
## END WHILE ##

endGame:

# end the program nicely
end:
li $v0 10
Syscall

endMain:
