# Années bissextiles

## Description

Ce programme détermine si une année saisie par l'utilisateur est bissextile. Il m'a permis de pratiquer les instructions logiques ET/OU ainsi que la logique booléenne en assembleur. Pour minimiser le nombre d'opérations, j'ai eu recours à une lookup table, évitant ainsi tout branchement conditionnel pour sélectionner le message à afficher.

## Logique du programme

Une année est bissextile si elle est divisible par 4 mais non par 100, ou si elle est divisible par 400. On pose les variables suivantes.

- *A* : l'année est divisible par 4 ;
- *B* : l'année est divisible par 100 ;
- *C* : l'année est divisible par 400 ;

| Valeur de A | Valeur de B | Valeur de C| Année bissextile? |
|-|-|-|-|
| faux | faux | faux | **faux** |
| faux | faux | vrai | *impossible* |
| faux | vrai | faux | *impossible* |
| faux | vrai | vrai | *impossible* |
| vrai | faux | faux | **vrai** |
| vrai | faux | vrai | *impossible* |
| vrai | vrai | faux | **faux** |
| vrai | vrai | vrai | **vrai** |

Cette table de vérité peut se traduire simplement via la condition suivante :

`(A && !B) || C` soit `(an % 4 == 0 && an % 100 != 0) || an % 400 == 0`

J'ai donc implémenté ce calcul booléen via 3 registres $\$t0$, $\$t1$ et $\$t2$ représentant les 3 variables booléennes ci-dessus.