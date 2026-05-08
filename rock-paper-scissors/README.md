# Pierre, feuille, ciseaux !

## Description

Une recréation du célèbre jeu pierre, feuille, ciseaux en assembleur MIPS. Le programme invite l'utilisateur à choisir entre les trois options en entrant un nombre, puis l'ordinateur effectue son choix de façon pseudo-aléatoire.

Ce projet m'a permis de mieux comprendre la logique de l'assembleur, et d'apprendre à utiliser le modulo, les tableaux, les entrées/sorties, ainsi que la gestion du pseudo aléatoire.

Le code n'est peut-être pas optimisé au maximum, mais il fonctionne sans bugs.

**Important : le programme ne gère pas les entrées invalides ! Il faut entrer une valeur correcte pour que tout se passe bien.**

## Logique du jeu

Le joueur choisit entre la Pierre (1), la Feuille (2) ou les Ciseaux (3). Sa saisie est ensuite ramenée dans l'intervalle [0-2]. L'ordinateur choisit également une valeur entre 0 et 2.

Le scénario de la partie est calculé via la concaténation binaire des deux choix : le choix de l'ordinateur occupe les bits de poids fort, celui du joueur les bits de poids faible. Le nombre obtenu appartient à l'ensemble {0, 1, 2, 4, 5, 6, 8, 9, 10}, où chaque valeur correspondant à un scénario unique.

Plutôt que d'enchaîner une série de conditions, le résultat de la partie est déterminé via une lookup table : un tableau pré-rempli indexé directement par l'encodage binaire des deux choix, ce qui évite tout branchement conditionnel et rend la logique plus simple et plus rapide.

| Choix ordi | Choix joueur | Choix ordi (binaire) | Choix joueur (binaire) | Nombre de la partie (décimal) | Valeur du résultat |
|:-:|:-:|-:|-:|-:|-:|
| pierre | pierre | 00 | 00 | 0 | 0 |
| pierre | feuille | 00 | 01 | 1 | 1 |
| pierre | ciseaux | 00 | 10 | 2 | 2 |
| feuille | pierre | 01 | 00 | 4 | 2 |
| feuille | feuille | 01 | 01 | 5 | 0 |
| feuille | ciseaux | 01 | 10 | 6 | 1 |
| ciseaux | pierre | 10 | 00 | 8 | 1 |
| ciseaux | feuille | 10 | 01 | 9 | 2 |
| ciseaux | ciseaux | 10 | 10 | 10 | 0 |

| Valeur du résultat | Signification |
|-:|-|
| 0 | Égalité |
| 1 | Le joueur gagne |
| 2 | L'ordinateur gagne |

La lookup table vaut précisément (0, 1, 2, 9, 2, 0, 1, 9, 1, 2, 0). Les 9 sont des valeurs arbitraires qui de toute manière, ne seront jamais atteintes.
