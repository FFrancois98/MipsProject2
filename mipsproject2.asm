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
