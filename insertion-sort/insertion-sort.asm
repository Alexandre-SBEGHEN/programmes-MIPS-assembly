	.data
str_T:		.asciiz	"T : "
TailleT:	.word	10
T:			.word	1, 3, 5, 2, 9, 8, 6, 4, 7, 0
	.text
# ---------- Programme principal
main:
	la $s0, T						# s0 = @T
	la $s1, TailleT					# s1 = @TailleT
	lw $s1, 0($s1)					# s1 = TailleT

	# ----- Afficher tableau
	or $a0, $zero, $s0				# arg0 = @T
	or $a1, $zero, $s1				# arg1 = TailleT
	jal AfficherTableau				# AfficherTableau()
	
	# ----- Trier tableau
	or $a0, $zero, $s0				# arg0 = @T
	or $a1, $zero, $s1				# arg1 = TailleT
	jal Sort						# Sort()
	
	# ----- Afficher tableau
	or $a0, $zero, $s0				# arg0 = @T
	or $a1, $zero, $s1				# arg1 = TailleT
	jal AfficherTableau				# AfficherTableau()
		
	# ----- Fin programme
	ori $v0, $zero, 10				# exit
	syscall

exit_func:
	jr $ra

# ---------- Afficher un tableau
AfficherTableau:
	or $t0, $zero, $a0				# t0 = @T
	or $t1, $zero, $zero			# i = 0
	
	ori $v0, $zero, 4				# print string
	la $a0, str_T					# string = str_T
	syscall							# affichage
	
	AfficherTableau_for:
		# condition sortie
		slt	$t2, $t1, $a1						# t2 = (i < N)
		beq $t2, $zero, AfficherTableau_exit
		
		ori $v0, $zero, 11			# print char
		ori $a0, $zero, 32			# char = Espace
		syscall						# affichage
		syscall						# affichage
		
		ori $v0, $zero, 1			# print int
		lw $a0, 0($t0)				# int = T[i]
		syscall						# affichage
		
		# ++i; goto for
		addi $t1, $t1, 1			# ++i
		addi $t0, $t0, 4			# @T += 4
		j AfficherTableau_for
	
	AfficherTableau_exit:
		ori $v0, $zero, 11			# print char
		ori $a0, $zero, 10			# char = \n
		syscall
		
		jr $ra
		

# ---------- Echanger les valeur k et k+1 d'un tableau
Swap:
	# Sauvegarder les valeurs de t0, t1, t2, a0
	addi $sp, $sp, -16				# allouer 4 cases
	sw $t0, 0($sp)					# sp[0] = t0
	sw $t1, 4($sp)					# sp[1] = t1
	sw $t2, 8($sp)					# sp[2] = t2
	sw $a0, 12($sp)					# sp[3] = a0
	
	sll $a1, $a1, 2					# k *= 4
	add $t0, $a0, $a1				# addresse de T + k
	
	lw $t1, 0($t0)					# t1 = T[k]
	lw $t2, 4($t0)					# t2 = T[k+1]
	
	sw $t2, 0($t0)					# T[k] = t2
	sw $t1, 4($t0)					# T[k+1] = t1
	
	# Restaurer t0, t1, t2, a0
	lw $t0, 0($sp)					# t0 = sp[0]
	lw $t1, 4($sp)					# t1 = sp[1]
	lw $t2, 8($sp)					# t2 = sp[2]
	lw $a0, 12($sp)					# a0 = sp[3]
	addi $sp, $sp, 16				# libérer la mémoire
	
	jr $ra							# sortie fonction

# ---------- Trier un tableau
# a0 = T
# a1 = N
# t0 = i
# t1 = i < N 
# t2 = j
# t3 = (j >= 0)
# t4 = T[j]
# t5 = T[j+1] + 1
# t6 = ( T[j+1] > T[j+1] )
# t7 = ( (j>=0) && (T[j] > T[j+1]) )
Sort:
	ori $t0, $zero, 1						# i = 1
	Sort_for_i:
		# --- Conditions de sortir de la boucle for i
		slt $t1, $t0, $a1					# i < N 
		beq $t1, $zero, Sort_for_i_end		# goto for_i_end if (i >= N)
	
		add $t2, $t0, -1					# j = i-1
		Sort_for_j:
			# --- Conditions de sortir de la boucle for j
			slt $t3, $t2, $zero				# j < 0
			xori $t3, $t3, 1				# j >= 0
			
			sll $t4, $t2, 2					# t4 = 4 * j
			add $t4, $t4, $a0				# t4 = a0 + 4 * j = @T[j]
			lw $t4, 0($t4)					# t4 = T[j]
			
			sll $t5, $t2, 2					# t5 = 4 * j
			addi $t5, $t5, 4				# t5 = 4 * (j+1)
			add $t5, $t5, $a0				# t5 = a0 + 4 * (j+1) = @T[j+1]
			lw $t5, 0($t5)					# t5 = T[j+1]
			addi $t5, $t5, 1				# t5 = T[j+1] + 1
			
			slt $t6, $t4, $t5				# t6 = ( T[j+1] < T[j+1] + 1 )
			xori $t6, $t6, 1				# t6 = ( T[j+1] >= T[j+1] + 1 ) = ( T[j+1] > T[j+1] )
			
			and $t7, $t3, $t6				# t7 = ( (j>=0) && (T[j] > T[j+1]) )
			
			beq $t7, $zero, Sort_for_j_end	# goto for_j_end if not t7
			
			
			# Sauvegarder les valeurs de a0, a1, ra
			addi $sp, $sp, -12				# allouer 3 cases
			sw $a0, 0($sp)					# sp[0] = a0
			sw $a1, 4($sp)					# sp[1] = a1
			sw $ra, 8($sp)					# sp[2] = ra
			
			# Effectuer le swap
			or $a1, $zero, $t2				# mettre j en argument
			jal Swap						# Swap(T, j)
			
			# Restaurer a0, a1, ra
			lw $a0, 0($sp)					# a0 = sp[0]
			lw $a1, 4($sp)					# a1 = sp[1]
			lw $ra, 8($sp)					# ra = sp[2]
			addi $sp, $sp, 12				# libérer la mémoire
			
			addi $t2, $t2, -1				# --j
			j Sort_for_j					# recommencer boucle j
			
		Sort_for_j_end:
		
		addi $t0, $t0, 1					# ++i
		j Sort_for_i						# recommencer boucle i
	Sort_for_i_end:
		jr $ra	
