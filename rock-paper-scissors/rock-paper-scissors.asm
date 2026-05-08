# -------------------- Explication (choix, résultat) d'une partie
# CHOIX POSSIBLES
# 0 = pierre
# 1 = feuille
# 2 = ciseaux
#
# RESULTAT
# 0 = partie nulle
# 1 = joueur gagne
# 2 = ordi gagne (joueur perd)
#
# PARTIES POSSIBLES
# J2 J1		Nombre décimal de la partie	Résultat
# 00 00		0				0
# 00 01		1				1
# 00 10		2				2
#
# 01 00		4				2
# 01 01		5				0
# 01 10		6				1
# 
# 10 00		8				1
# 10 01		9				2
# 10 10		10				0
# --------------------
	.data
str_p1:		.asciiz	"Choisissez la Pierre (1), la Feuille (2), ou les Ciseaux (3) : "
str_r1:		.asciiz "Vous avez choisi :      "
str_r2:		.asciiz "L'ordinateur a choisi : "
str_r:		.asciiz "Pierre\n"
str_p:		.asciiz "Feuille\n"
str_c:		.asciiz "Ciseaux\n"
str_tie:	.asciiz	"\nÉgalité !"
str_win:	.asciiz "\nVous avez gagné !\n"
str_loo:	.asciiz	"\nVous avez perdu... :(\n"
arr_restable:	.word	0, 1, 2, 9, 2, 0, 1, 9, 1, 2, 0	# Tableau qui définie les parties gagnantes, perdantes, et nulles (9 = valeur inatteignable)
arr_rpc:	.word	str_r, str_p, str_c		# Tableau des strings des choix
arr_res:	.word	str_tie, str_win, str_loo	# Tableau des strings des résultats
	.text
main:	
	# ---------- Choix Joueur 1
	ori $v0, $zero, 4		# print string
	la $a0, str_p1			# message = str_p1
	syscall				# affichage
	
	ori $v0, $zero, 5		# read int
	syscall				# lecture
	subi $s0, $v0, 1		# décrémenter pour que le premier soit 0
	
	
	
	# ---------- Choix Ordinateur
	ori $v0, $zero, 42		# random int range
	ori $a0, $zero, 0		# seed à 0
	ori $a1, $zero, 300		# borne maximale à 30 exclu [0-29]
	syscall				# génération
	or $s1, $zero, $a0		# mettre le nombre enregistré dans s1
	
	ori $t0, $zero, 3		# mettre le diviseur pour le modulo dans t0
	div $s1, $t0			# effectuer la division de s1 par 3 (t0)
	mfhi $s1			# mettre le modulo dans s1 (le choix final de l'ordi)
	
	
	
	# ---------- Calcul résultat
	sll $s2, $s1, 2			# décaler le choix de l'ordi de 2 bits à gauche dans s2
	or $s2, $s2, $s0		# inclure le choix du joueur dans s2
	
	la $t0, arr_restable		# charger le tableau des résultats
	sll $t1, $s2, 2			# partie -> index dans le tableau
	add $t1, $t0, $t1		# calculer l'adresse du résultat correspondant à la partie
	lw $s2, 0($t1)			# charger le résulat dans s2
	
	
	
	# ---------- Affichage résultat
	jal f_linebreak
	
	la $t0, arr_rpc			# charger le tableau des choix (en string)
	sll $t1, $s0, 2			# choix du joueur -> index
	add $t1, $t0, $t1		# calculer l'adresse du string du choix du joueur
	lw $t1, 0($t1)			# charger le string dans t1
	
	sll $t2, $s1, 2			# choix de l'ordi -> index dans le tableau des choix
	add $t2, $t0, $t2		# calculer l'adresse du string du choix de l'ordi
	lw $t2, 0($t2)			# charger le string dans t2
	
	ori $v0, $zero 4		# print string
	la $a0, str_r1			# message = str_r1
	syscall				# affichage
	
	or $a0, $zero, $t1		# message = choix du joueur (en string)
	syscall				# affichage
	
	la $a0, str_r2			# message = str_r2
	syscall				# affichage
	
	or $a0, $zero, $t2		# message = choix de l'ordi (en string)
	syscall				# affichage
	
	ori $v0, $zero, 4		# print string
	la $t0, arr_res			# charger les phrases de fin
	sll $t1, $s2, 2			# résultat de la partie -> index
	add $t1, $t0, $t1		# calculer l'adresse du message
	lw $a0, 0($t1)			# message = le résultat de la partie
	syscall				# affichage
	
end:	
	ori $v0, $zero, 10
	syscall
	
f_linebreak: # Afficher un retour à la ligne
	ori $v0, $zero, 11		# print char
	ori $a0, $zero, 10		# caractère \n
	syscall				# affichage
	jr $ra				# sortie

	


