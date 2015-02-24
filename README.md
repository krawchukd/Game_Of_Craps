# Game_Of_Craps
Games of Craps written in MIPS assembly language.

This program simulates the game of Craps :
 Here is the basic setup:
 1. The game involves two dice. Each die has six faces. These faces contain 1, 2, 3, 4, 5 and 6 spots, respectively.
 2. The player plays against the "house", rather than against another player.
 3. Note that the first throw of the dice is handled differently than subsequent throws.
 
 Here is how the game is played:
 1. The player rolls two dice.
 2. After the dice have come to rest, the player adds the spots on the two upward faces to
 get their sum.
 3. If the sum is 7 or 11 on the first throw, the player wins.
 4. If the sum is 2, 3 or 12 on the first throw (these three values are called "craps"), the
 player loses (i.e., the "house" wins).
 5. If the sum is 4, 5, 6, 8, 9 or 10 on the first throw, this special number becomes the
 player's "point".
 6. To win, the player must continue rolling the dice until he/she "makes his/her point" (i.e.,
 rolls the special point value again).
 7. The player loses by rolling a 7 before making the point.

 Note : Convention followed for working with stack is as follows: 
    		Caller stores needed values on stack and restores needed values back upon return from function block.
      	Callee has no responsibilities to registers.

