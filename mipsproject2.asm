.data

notNum:	.asciiz	"NaN "
tooLargeString:		.asciiz	"Large String "
comma:					.asciiz	" "
userInput:				.space	1001
userSubString:				.space	1001

.globl main

.text

main:
	li $v0, 8						#Read in string
	la $a0, userInput				#Store string in buffer
	li $a1, 1001					#Limit size to 1000
	syscall
	
	la $s1, userSubString				#Save address of userSubString in $s1
	la $s2, ($a0)					#Move address of input string to $s2
	la $s3, userSubString				#Copy of userSubString to know where to start printing
	and $t8, $t8, $zero				#Flag when non-terminating char/space has been read
	and $t9, $t9, $zero				#Current string length counter (8 max length)
	
loop:
	lb $s0, 0($s2)					#Load character into $s0
	
	slti $t1, $t9, 9				#Check if current substring is longer than 8 characters
	beq $t1, $zero, length_error	#Throw length_error and skip to next comma
	
	beq $s0, $zero, print_strings	#Check if at end of input
	beq $s0, '\n', print_strings	#Check if at end of input
	beq $s0, ',', subStringProcess		#Process chars at the end of the current substring
	beq $s0, ' ', space_loop
	
	li $t8, 1						#Set seen valid character flag
	sb $s0, 0($s1)					#Save character in current string
	addi $s2, $s2, 1				#Go to next character from input
	addi $s1, $s1, 1				#Go to next empty place in userSubString
	addi $t9, $t9, 1				#Increment current substring length counter (max 8)
	
	j loop							#Continue loop
	

space_loop:
	addi $s2, $s2, 1				#Go to next character in current string
	lb $s0, 0($s2)					#Load character into $s0
	beq $s0, ' ', space_loop		#Skip space if at the beginning or at the end
	beq $s0, '\t', space_loop
	beq $s0, $zero, print_strings	#Check if at end of input
	beq $s0, '\n', print_strings	#Check if at end of input
	beq $s0, ',', subStringProcess		#Process chars at the end of the current substring
	
	j is_valid						#Check if this is a valid char after reading spaces
	

is_valid:
	bne $t8, $zero, main_error		#If previous valid char has been read then NaN
	sb $s0, 0($s1)					#First valid char encountered so save in userSubString
	li $t8, 1						#Set seen valid character flag
	or $s3, $zero, $s1				#Update current string head pointer
	addi $s1, $s1, 1				#Go to next empty place in userSubString
	addi $s2, $s2, 1				#Go to next character from input
	addi $t9, $t9, 1				#Increment current substring length counter (max 8)
	
	j loop							#Back to main loop

	
subStringProcess:
	la $a0, ($s3)					#Load beginning of current substring into $a0 as argument
	beq $t8, $zero, main_error		#If letter has not been seen then string is not valid
	jal subprogram_2						#Go to subroutine 2
	
	addi $s2, $s2, 1				#Go to next character from input
	and $t8, $t8, $zero				#Reset seen valid character flag
	and $t9, $t9, $zero				#Reset substring counter
	or $s3, $s1, $zero				#Move head pointer of userSubString to next substring beginning
	
	j loop							#Go back to main loop
	
	
print_strings:
	la $a0, ($s3)					#Load beginning of current substring into $a0 as argument
	lb $t1, 0($s3)					#Load first character in current substring
	beq $t1, '\n', end				#Check if at end of input string
	beq $t1, $zero, end				#Check if at end of input string
	jal subprogram_2						#Go to subroutine 2
	j end


length_error:
	la $a0, tooLargeString		#Load address of notNum
	li $v0, 4						#Print notNum
	syscall
	
	add $s1, $s1, $t9				#Move pointer for writing to current string to an empty cell
	or $s3, $zero, $s1				#Update the head of current string accordingly
	and $t8, $t8, $zero				#Reset seen valid character flag
	and $t9, $t9, $zero				#Reset substring counter
	j skip_loop						#Skip to next substring
