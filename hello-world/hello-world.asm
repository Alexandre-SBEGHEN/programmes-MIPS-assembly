	.data
str:	.asciiz	"Salut !"
	.text
main:	
	ori $v0, $zero, 4
	la $a0, str
	syscall
	
	ori $v0, $zero, 10
	syscall