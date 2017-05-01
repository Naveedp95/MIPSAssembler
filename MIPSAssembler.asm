.data
tokens: .byte '\0':8000 #length of ea array is sqrt(#)
tokenOffset: .word 8 #memory allocation
filename: .asciiz "InstructionRead.txt" #file name
fout: .asciiz "Output.txt"
textSpace: .space 10500
beep: .byte 79
duration: .byte 1270
volume: .byte 127
song: .byte 79
endData:
#ignored chars
Token: .asciiz "\n"
InstFormatStatus: .word 1 



atOP: .asciiz "00001"
addOP: .asciiz "100000" 
addiOP: .asciiz "001000" 
addiuOP: .asciiz "001001" 
adduOP: .asciiz "100001" 
andOP: .asciiz "100100" 
andiOP: .asciiz "001100" 
beqOP: .asciiz "000100"
bneOP: .asciiz "000101"
jOP: .asciiz "000010"
jalOP: .asciiz "000011"
jrOP: .asciiz "001000"
lbuOP: .asciiz "100100"
lhuOP: .asciiz "100101"
liOP: .asciiz "110000"
luiOP: .asciiz "001111"
lwOP: .asciiz "100011"
norOP: .asciiz "100111"
orOP: .asciiz "100101"
oriOP: .asciiz "001101"
sltOP: .asciiz "101010"
sltiOP: .asciiz "001010"
sltiuOP: .asciiz "001011"
sltuOP: .asciiz "101011"
sllOP: .asciiz "000000"
srlOP: .asciiz "000010"
sbOP: .asciiz "101000"
scOP: .asciiz "111000"
shOP: .asciiz "101001"
swOP: .asciiz "101011"
subOP: .asciiz "101000"
subuOP: .asciiz "100011"
divOP: .asciiz "011010"
divuOP: .asciiz "011011"
lwclOP: .asciiz "110001"
ldclOP: .asciiz "110101"
mfhiOP: .asciiz "010000"
mfloOP: .asciiz "010010" 
multOP: .asciiz "011000"
multuOP: .asciiz "011001"
sraOP: .asciiz "000011"
swclOP: .asciiz "111001"
sdclOP: .asciiz "111101"

V0OP: .asciiz "00010"
V1OP: .asciiz "00011"

A0OP: .asciiz "00100"
A1OP: .asciiz "00101"
A2OP: .asciiz "00110"
A3OP: .asciiz "00111"

T0OP: .asciiz "01000"
T1OP: .asciiz "01001"
T2OP:.asciiz "01010"
T3OP:.asciiz "01011"
T4OP:.asciiz "01100"
T5OP:.asciiz "01101"
T6OP:.asciiz "01110"
T7OP:.asciiz "01111"

S0OP: .asciiz "10000"
S1OP: .asciiz "10001"
S2OP: .asciiz "10010"
S3OP: .asciiz "10011"
S4OP: .asciiz "10100"
S5OP: .asciiz "10101"	
S6OP: .asciiz "10110"
S7OP: .asciiz "10111"

T8OP: .asciiz "11000"
T9OP: .asciiz "11001"

fivezeroes: .asciiz "00000"
sixzeroes: .asciiz "000000"
.text
main:
	li $v0, 13           #open a file
	li $a1, 0            # file flag (read)
	la $a0, filename     # load file name
	add $a2, $zero, $zero    # file mode (unused)
	syscall

	move $a0, $v0        # load file descriptor
	li $v0, 14           #read from file
	la $a1, textSpace        # allocate space for the bytes loaded
	li $a2, 10500
	syscall
	
	la $a0, textSpace #arg1 chracters read from file 
	la $a1, tokens # arg2 tokens made from characters
	jal tokenize
	
	li $v0, 16
	syscall
	
	li $v0, 13
    	la $a0, fout
    	li $a1, 1
    	li $a2, 0
    	syscall
    	move $s6, $v0
	
			
	add $t0,$zero,$zero
	add $t2,$zero,$zero
	la $t1, tokens
	jal InstructionFormat
	
	
	
printLoop:
	

	lwr $a0, ($t1)
	beq $t0,1000,SoundCompleted
	beq $a0, 0x00646461, AddPrint	
	beq $a0, 0x69646461, AddiPrint
	#beq $a0, 0x7569646461, AddiuPrint
	beq $a0, 0x75646461, AdduPrint
	beq $a0, 0x646e61, AndPrint
	beq $a0, 0x69646e61, AndiPrint
	beq $a0, 0x716562, BeqPrint
	beq $a0, 0x656e62, BnePrint
	beq $a0, 0x6a, JPrint
	beq $a0, 0x6c616a, JalPrint
	beq $a0, 0x7261, JrPrint
	beq $a0, 0x75626c, LbuPrint
	beq $a0, 0x75686c, LhuPrint
	beq $a0, 0x696c, LiPrint
	beq $a0, 0x69756c, LuiPrint
	beq $a0, 0x776c, LwPrint
	beq $a0, 0x726f6e, NorPrint
	beq $a0, 0x726f, OrPrint
	beq $a0, 0x69726f, OriPrint
	beq $a0, 0x746c73, SltPrint
	beq $a0, 0x69746c73, SltiPrint
	#beq $a0, 0x7569746c73, SltiuPrint
	beq $a0, 0x75746c73, SltuPrint
	beq $a0, 0x6c6c73, SllPrint
	beq $a0, 0x6c7273, SrlPrint
	beq $a0, 0x6273, SbPrint
	beq $a0, 0x6373, ScPrint
	beq $a0, 0x6873, ShPrint
	beq $a0, 0x7773, SwPrint
	beq $a0, 0x627573, SubPrint
	beq $a0, 0x75627573, SubuPrint
	beq $a0, 0x766964, DivPrint
	beq $a0, 0x75766964, DivuPrint
	beq $a0, 0x6968666d, MfhiPrint
	beq $a0, 0x6f6c666d, MfloPrint
	beq $a0, 0x746c6d, MultPrint
	beq $a0, 0x75746c6d, MultuPrint
	beq $a0, 0x6c637773, SwclPrint
	beq $a0, 0x6c636473, SdclPrint
	beq $a0, 0x00307624, v0Print
	beq $a0, 0x00317624, v1Print
	beq $a0, 0x00306124, a0Print
	beq $a0, 0x00316124, a1Print
	beq $a0, 0x00326124, a2Print
	beq $a0, 0x00336124, a3Print
	beq $a0, 0x00307424, t0Print
	beq $a0, 0x00317424, t1Print
	beq $a0, 0x00327424, t2Print
	beq $a0, 0x00337424, t3Print
	beq $a0, 0x00347424, t4Print
	beq $a0, 0x00357424, t5Print
	beq $a0, 0x00367424, t6Print
	beq $a0, 0x00377424, t7Print
	beq $a0, 0x00387424, t8Print 
	beq $a0, 0x00397424, t9Print 
	beq $a0, 0x00307324, s0Print
	beq $a0, 0x00317324, s1Print
	beq $a0, 0x00327324, s2Print
	beq $a0, 0x00337324, s3Print
	beq $a0, 0x00347324, s4Print
	beq $a0, 0x00357324, s5Print
	beq $a0, 0x00367324, s6Print
	beq $a0, 0x00377324, s7Print
	beq $a0, 0x00746124, atPrint
	j exitL
	
atPrint:
	li $v0, 15
    	move $a0, $s6
    	la $a1, atOP
    	li $a2, 5
    	syscall
    	j exitL
v0Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, V0OP
    	li $a2, 5
    	syscall
    	j exitL
	
v1Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, V1OP
    	li $a2, 5
    	syscall
    	j exitL
a0Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, A0OP
    	li $a2, 5
    	syscall
    	j exitL
a1Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, A1OP
    	li $a2, 5
    	syscall
    	j exitL
a2Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, A2OP
    	li $a2, 5
    	syscall
    	j exitL
a3Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, A3OP
    	li $a2, 5
    	syscall
    	j exitL
t0Print:
	li $v0, 15
   	move $a0, $s6
    	la $a1, T0OP
    	li $a2, 5
    	syscall
    	j exitL
t1Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, T1OP
    	li $a2, 5
    	syscall
    	j exitL
t2Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, T2OP
    	li $a2, 5
    	syscall
    	j exitL
t3Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, T3OP
    	li $a2, 5
    	syscall
    	j exitL
t4Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, T4OP
    	li $a2, 5
    	syscall
    	j exitL
t5Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, T5OP
    	li $a2, 5
    	syscall
    	j exitL
t6Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, T6OP
    	li $a2, 5
    	syscall
    	j exitL
t7Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, T7OP
    	li $a2, 5
    	syscall
    	j exitL
t8Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, T8OP
    	li $a2, 5
    	syscall
    	j exitL
t9Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, T9OP
    	li $a2, 5
    	syscall
    	j exitL
s0Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, S0OP
    	li $a2, 5
    	syscall
    	j exitL
s1Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, S1OP
    	li $a2, 5
    	syscall
    	j exitL
s2Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, S2OP
    	li $a2, 5
    	syscall
    	j exitL
s3Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, S3OP
    	li $a2, 6
    	syscall
    	j exitL
s4Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, S4OP
    	li $a2, 5
    	syscall
    	j exitL
s5Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, S5OP
    	li $a2, 5
    	syscall
    	j exitL
s6Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, S6OP
    	li $a2, 5
    	syscall
    	j exitL
s7Print:
	li $v0, 15
    	move $a0, $s6
    	la $a1, S7OP
    	li $a2, 5
    	syscall
    	j exitL

AddPrint:
  #write on file
    #open
    

    #write
    li $v0, 15
    move $a0, $s6
    la $a1, addOP
    li $a2, 6
    syscall
    j exitL

    #close

	
	
	
AddiPrint:
    li $v0, 15
    move $a0, $s6
    la $a1, addiOP
    li $a2, 6
    syscall
    j exitL
	 


AddiuPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, addiuOP
    li $a2, 6
    syscall
    j exitL
AdduPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, adduOP
    li $a2, 6
    syscall
    j exitL
AndPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, andOP
    li $a2, 6
    syscall
    j exitL	
AndiPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, andiOP
    li $a2, 6
    syscall
    j exitL
BeqPrint:	
	li $v0, 15
    move $a0, $s6
    la $a1, beqOP
    li $a2, 6
    syscall
    j exitL	
BnePrint:
	li $v0, 15
    move $a0, $s6
    la $a1, bneOP
    li $a2, 6
    syscall
    j exitL
JPrint: 
	li $v0, 15
    move $a0, $s6
    la $a1, jOP
    li $a2, 6
    syscall
    j exitL
JalPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, jalOP
    li $a2, 6
    syscall
    j exitL
JrPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, jrOP
    li $a2, 6
    syscall
    j exitL
LbuPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, lbuOP
    li $a2, 6
    syscall
    j exitL
LhuPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, lhuOP
    li $a2, 6
    syscall
    j exitL
LiPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, liOP
    li $a2, 6
    syscall
    j exitL	
LuiPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, luiOP
    li $a2, 6
    syscall
    j exitL
LwPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, lwOP
    li $a2, 6
    syscall
    j exitL
NorPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, norOP
    li $a2, 6
    syscall
    j exitL
OrPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, orOP
    li $a2, 6
    syscall
    j exitL
OriPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, oriOP
    li $a2, 6
    syscall
    j exitL
SltPrint:	
	li $v0, 15
    move $a0, $s6
    la $a1, sltOP
    li $a2, 6
    syscall
    j exitL
SltiPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, sltiOP
    li $a2, 6
    syscall
    j exitL	
SltiuPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, sltiuOP
    li $a2, 6
    syscall
    j exitL
SltuPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, sltuOP
    li $a2, 6
    syscall
    j exitL	
SllPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, sllOP
    li $a2, 6
    syscall
    j exitL
SrlPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, srlOP
    li $a2, 6
    syscall
    j exitL
SbPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, sbOP
    li $a2, 6
    syscall
    j exitL
ScPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, scOP
    li $a2, 6
    syscall
    j exitL
ShPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, shOP
    li $a2, 6
    syscall
    j exitL
SwPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, swOP
    li $a2, 6
    syscall
    j exitL
SubPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, subOP
    li $a2, 6
    syscall
    j exitL
SubuPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, subuOP
    li $a2, 6
    syscall
    j exitL
DivPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, divOP
    li $a2, 6
    syscall
    j exitL
DivuPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, divuOP
    li $a2, 6
    syscall
    j exitL	
LwclPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, lwclOP
    li $a2, 6
    syscall
    j exitL
LdclPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, ldclOP
    li $a2, 6
    syscall
    j exitL
MfhiPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, mfhiOP
    li $a2, 6
    syscall
    j exitL
MfloPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, mfloOP
    li $a2, 6
    syscall
    j exitL

MultPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, multOP
    li $a2, 6
    syscall
    j exitL
MultuPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, multuOP
    li $a2, 6
    syscall
    j exitL
SraPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, sraOP
    li $a2, 6
    syscall
    j exitL
SwclPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, swclOP
    li $a2, 6
    syscall
    j exitL
SdclPrint:
	li $v0, 15
    move $a0, $s6
    la $a1, sdclOP
    li $a2, 6
    syscall
    j exitL
shamtPrintRFormat:	#prints the shamt 5 0's for R instructions that don't require shamt
	li $v0, 15
	move $a0, $s6
    la $a1, fivezeroes
    li $a2, 5
    syscall
    addi $s2, $s2, 1
    jr $ra
SixZeroesRFormat:	#prints the first 6 0's for all R instructions
	li $v0, 15
	move $a0, $s6
    la $a1, sixzeroes
    li $a2, 6
    syscall
    jr $ra
NewLine:
	addi $v0, $0, 15
	move $a0, $s6
	la $a1, Token
	li $a2, 1
	syscall
	j InstructionFormat
	
exitL:
	addi $s2, $s2, 1
	addi $t0,$t0,1
	add $t1,$t1,8
	jal argumenttracker
	#add $t9,$t9,8
	
	
	li $v0, 11
	la $a0, ' '
	syscall
	
	b printLoop
	
argumenttracker:
	li $t5, 3
	beq $s3, $s2, NewLine
	beq $t5, $s2 specialtrackershamtRFormat
arugmenttrackerreturn:	
	jr $ra
	
specialtrackershamtRFormat:	
	la  $t2, InstFormatStatus
	addi $t6, $zero, 1
	lw $t3, ($t2)
	bne $t3, $t6, specialtrackershamtRFormatEnd
	j shamtPrintRFormat
specialtrackershamtRFormatEnd:
	j arugmenttrackerreturn

	
SoundCompleted:
	li $v0,31
	la $t0,song 
	lbu $a0,19($t0) 
	addi $t2,$a0,12 
	la $t1,duration 
	lbu $a1,0($t1) 
	la $t3,volume 
	lbu $a3,0($t3) 
	move $t4,$a0 
	move $t5,$a1 
	move $t6,$a3 
	syscall
	j end
	#Exit
	

	#subroutine 
tokenize: #s0,s1 to hold buffer and tokens resp. $s2,$s3 to hold the data inside arddr of s0,s1 resp.
		la $s0, textSpace #s2 has data
		la $s1, tokens #s3 has data
		lb $s2, ($s0) #load first file string char
		add $t0,$zero,$zero #set to zero for 2 array row counter
		tokenLineIgnLoop:
		
			#while buffer[i]!=  \0 OR '#'
			beq $s2, $zero,  return_tokenLineIgnLoop 
			#if current char is null then exit
			beq $s2, 35,  return_tokenLineIgnLoop
			
			
			#beq $s2, 9, Ex_tokenInstrIgnLoop # file input is #(35) leave
			#beq $s2, 13,  return_tokenLineIgnLoop # file input is \r(12) leave
			tokenInstrIgnLoop:
				#while buffer[i]!= ' ' OR ',' OR '\t'
				beq $s2, $zero,  return_tokenLineIgnLoop #if current char is null then exit
				beq $s2, 35,  return_tokenLineIgnLoop # file input is #(35) leave
				beq $s2, 13,  Ex_tokenInstrIgnLoop # file input is \r(12) leave
				#if char is space, comma or tab then go outside this while loop
				beq $s2, 44, Ex_tokenInstrIgnLoop
				beq $s2, 32, Ex_tokenInstrIgnLoop
				beq $s2, 10, Ex_tokenInstrIgnLoop
				sb $s2, ($s1) # store the char into the addr of 2 token array
				addi $s0, $s0,1 #goto next addr of file IO
				addi $s1, $s1,1 # go to next element/col 
				lb $s2, ($s0) #get the char from the addr
				b tokenInstrIgnLoop
			Ex_tokenInstrIgnLoop:
				addi $s0, $s0,1 #increment by file input by 1
				lb $s2, ($s0) #load character
				beq $s2, 44, Ex_tokenInstrIgnLoop
				beq $s2, 32, Ex_tokenInstrIgnLoop
				beq $s2, 10, Ex_tokenInstrIgnLoop
				beq $s2, $zero,  return_tokenLineIgnLoop #if current char is null then exit
				beq $s2, 35,  return_tokenLineIgnLoop # file input is #(35) leave
				beq $s2, 13,  Ex_tokenInstrIgnLoop # file input is \r(12) leave
				la $s1, tokens #load 2d array first element/addr
				addi $t0,$t0,8 #add 8 for the next row
				add $s1, $s1,$t0 # add next row offset to 2d array addr	
				b tokenLineIgnLoop
			return_tokenLineIgnLoop:
				jr $ra
				
rFormat:    #R format RD = RS + RT --> opcode RS RT RD shamt funct
	add $s2, $zero, $zero
	li $s3, 5 # num of binary strings to print for tracking minus the first 6
	lwr $t4, ($t1) # reorganize the elements of the instruction for the R format
	lwr $s4, 8($t1)		# stores instruction,RD, RS, and RT temporarily 
	lwr $s5, 16($t1)	
	lwr $s7, 24($t1)
	swr $s5, ($t1)	#RS is first now
	swr $s7, 8($t1)	#RT is second
	swr $s4, 16($t1)	#RD is third
	swr $t4, 24($t1) #instruction is fourth for not anticipating a shamt value
	la  $t4, InstFormatStatus
	addi $t5, $zero, 1
	sw $t5, ($t4)
	j SixZeroesRFormat
iFormat:	#I format RT RS IMM	--> opcode RS RT IMM	
	add $t0, $zero, $zero
	li $s3, 4 # num of binary strings to print for tracking
	lwr $s4, 8($t1)	# reorganize the registers for the I format
	lwr $s5, 16($t1)	# stores RS and RT temporarily 
	swr $s5, 8($t1)	# RS is first
	swr $s4, 16($t1)	# RT is second
	la  $t4, InstFormatStatus
	addi $t5, $zero, 2
	sw $t5, ($t4)
	jr  $ra
jFormat:	#J format --> opcode IMM
InstructionFormat:
	lwr $a2, ($t1)
	beq $a2, 0x00646461, rFormat	 
	beq $a2, 0x69646461, iFormat	
	#beq $a2, 0x7569646461, AddiuPrint
	beq $a2, 0x75646461, rFormat
	beq $a2, 0x646e61, rFormat
	beq $a2, 0x69646e61, iFormat
	beq $a2, 0x716562, iFormat
	beq $a2, 0x656e62, iFormat
	beq $a2, 0x6a, jFormat
	beq $a2, 0x6c616a, jFormat
	beq $a2, 0x7261, rFormat
	beq $a2, 0x75626c, iFormat
	beq $a2, 0x75686c, iFormat
	beq $a2, 0x696c, iFormat
	beq $a2, 0x69756c, iFormat
	beq $a2, 0x776c, iFormat
	beq $a2, 0x726f6e, rFormat
	beq $a2, 0x726f, rFormat
	beq $a2, 0x69726f, iFormat
	beq $a2, 0x746c73, rFormat
	beq $a2, 0x69746c73, iFormat
	#beq $a2, 0x7569746c73, SltiuPrint
	beq $a2, 0x75746c73, rFormat
	beq $a2, 0x6c6c73,  rFormat
	beq $a2, 0x6c7273,  rFormat
	beq $a2, 0x6273,    iFormat
	beq $a2, 0x6373,     iFormat
	beq $a2, 0x6873,     iFormat
	beq $a2, 0x7773,     iFormat
	beq $a2, 0x627573,   rFormat
	beq $a2, 0x75627573, rFormat
	beq $a2, 0x766964,   rFormat
	beq $a2, 0x75766964, rFormat
	beq $a2, 0x6968666d, rFormat
	beq $a2, 0x6f6c666d, rFormat
	beq $a2, 0x00746c6d, rFormat
	#beq $a0, 0x75746c6d, MultuPrint
	beq $a2 0x6c637773, rFormat
	beq $a2, 0x6c636473, iFormat
	jr  $ra
	
end:	
	li $v0, 16
    	move $a0, $s6
    	syscall
	li $v0, 10
	syscall
