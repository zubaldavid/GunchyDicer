.data

start:
	.ascii"Welcome to David's Gunchy Dicer!\n\0"
own:
	.ascii"You currently have $\0"
bet:
	.ascii"Enter your bet: $\0"
you:
	.ascii"You rolled a: \0"
tom:
	.ascii"Tom rolled a: \0"
win: 
	.ascii"You win!\n\n\0"
win1:
	.ascii"Victory belongs to the most persevering!\n\n\0"
win2:
	.ascii"Another win in the books.\n\n\0"
lose: 
	.ascii"You lose.\n\n\0"
lose1:
	.ascii"You don messed up :(\n\n\0"
lose2:
	.ascii"You need to pick up your game.\n\n\0"
tie:
	.ascii"You tied!\n\n\0"
done:
	.ascii"Looks like you ran out of money.\nThanks for playing!\n\0"
invalid:
	.ascii"Put some real money down! Try a positive number:\n\0"
balance:

	.long 100
new:
	.ascii"\n\0"
.text
.global _start

_start:
	mov $6, %eax
	call VTSetForeColor 
	mov $start, %eax
        call PrintStringC
	mov $7, %eax
	call VTSetForeColor 

Loop:
	mov $own, %eax	
	call PrintStringC
	mov balance, %eax
	call PrintInt
	mov %eax, balance 

	mov $new, %eax
	call PrintStringC

	mov $bet, %eax
	call PrintStringC

	call ScanInt
	cmp $1, %eax
	jge solid 
	mov $invalid, %eax
	call PrintStringC
	call ScanInt
	
solid:
	mov %eax, %edx		#bet is in EDX

	mov $you, %eax		#You roll 
	call PrintStringC	
	mov $6, %eax 
	call Random 		#runs dice1
	mov %eax, %ebx
	mov $6, %eax
	call Random		#runs dice 2
	add %ebx, %eax	 	#adds dice
	call PrintInt
	mov %eax, %ebx  	#I am now EBX
	
	mov $new, %eax 		#newline
	call PrintStringC	
	
	mov $tom, %eax		#Tom rolls
	call PrintStringC		
	mov $6, %eax
	call Random		#call dice1
	mov %eax, %ecx
	mov $6, %eax
	call Random		#call dice2
	add %ecx, %eax		#adds dice
	call PrintInt
	mov %eax, %ecx  	#Tom has ECX	

	mov $new, %eax
	call PrintStringC

	cmp %ecx, %ebx		# ebx(me) > ecx(tom) jump lower
	jl Sub 	
	je Tie
	
	mov $2, %eax		#color green
	call VTSetForeColor 
	mov $5, %eax
	call Random
	cmp $1, %eax
	jl W1
	jg W2
	je W
W:
	mov $win, %eax		#winner logic
	call PrintStringC
	jmp Next
W1:	
	mov $win1, %eax
	call PrintStringC
	jmp Next	
W2:	
	mov $win2, %eax
	call PrintStringC
Next:	
	mov $7, %eax		#color white
	call VTSetForeColor 
	add %edx, balance 
	cmp $1, balance
	jge Loop

Tie:				#TIED
	mov $5, %eax
        call VTSetForeColor 
	mov $tie, %eax
	call PrintStringC
	mov $7, %eax
        call VTSetForeColor 
	cmp $1, balance
	jge Loop	
		
Sub:
	mov $1, %eax		#red
	call VTSetForeColor 
	mov $5, %eax
	call Random
	cmp $2, %eax
	jl L1
	jg L2
	je L
L:
	mov $lose, %eax          #winner logic
        call PrintStringC
        jmp Next1
L1:
        mov $lose1, %eax
        call PrintStringC
        jmp Next1
L2:
        mov $lose2, %eax
        call PrintStringC
Next1:				#loser logic begins
	mov $7, %eax		#white
        call VTSetForeColor 
	sub %edx, balance
	cmp $0, balance
	jg Loop
	

DONE:
	mov $6, %eax		#cyan color
        call VTSetForeColor 
	mov $done, %eax
	call PrintStringC
	mov $7, %eax		#white color
        call VTSetForeColor 	
	call EndProgram

