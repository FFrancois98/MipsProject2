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
