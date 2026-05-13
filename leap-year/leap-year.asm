	.data
str_in:		.asciiz	"Veuillez entrer une année : "
str_result:	.asciiz	"RÉSULTAT : l'année "
str_yes:	.asciiz	" est bissextile.\n"
str_no:		.asciiz	" n'est pas bissextile.\n"
arr_answer:	.word	str_no, str_yes		#lookup table
	.text
main:
	# ----- Affichage de l'invite
	ori $v0, $zero, 4		# print string
	la $a0, str_in			# string = str_in
	syscall					# affichage
	
	# ----- Lecture de l'annnée
	ori $v0, $zero, 5		# read int
	syscall					# lecture
	or $s0, $zero, $v0		# s0 = année lue
	
	# ----- Calculation de la bissextilité :)
	ori $t0, $zero, 2		# préparer la division par 4
	ori $t1, $zero, 100		# préparer la division par 100
	ori $t2, $zero, 400		# préparer la division par 400
	
	div $s0, $t0			# année / 4
	mfhi $t0				# t0 = année % 4
	div $s0, $t1			# année / 100
	mfhi $t1				# t1 = année % 100
	div $s0, $t2			# année / 400
	mfhi $t2				# t2 = année % 400
	
	slti $t0, $t0, 1		# t0 = (t0 < 1)	<=>	(t0 == 0)	Le reste d'une div euclidienne est positif
	slti $t1, $t1, 1		# t1 = (t1 < 1)	<=>	(t1 == 0)
	xori $t1, $t1, 1		# t1 = (t1 != 0)
	slti $t2, $t2, 1		# t2 = (t2 < 1)	<=>	(t2 == 0)	Le reste d'une div euclidienne est positif
	
	and $s1, $t0, $t1		# s1 = (t0 && !t1)	<=>	(an % 4 == 0 && an % 100 != 0)
	or $s1, $s1, $t2		# s1 = (s1 || t2)	<=>	(an % 4 == 0 && an % 100 != 0) || an % 400 == 0
	
	# ----- Affichage du résultat
	ori $v0, $zero, 4		# print string
	la $a0, str_result		# string = str_in
	syscall					# affichage
	
	ori $v0, $zero, 1		# print int
	or $a0, $zero, $s0		# int = année lue
	syscall					# affichage
	
	sll $t0, $s1, 2			# t0 = 4 * s1
	la $t1, arr_answer		# t1 = @arr_answer
	add $t1, $t1, $t0		# t1 = @arr_answer[s1]
	lw $a0, 0($t1)			# a0 = string = arr_answer[s1]
	ori $v0, $zero, 4		# print string
	syscall					# affichage
	
	# ----- Fin du programme
	ori $v0, $zero, 10		#exit
	syscall