# Tri par insertion

## Description

Ce programme est issu de mon TD de MIPS. L'objectif était de transposer en assembleur un algorithme de tri par insertion écrit en C++. Ce travail m'a permis de manipuler la gestion de la pile pour les allocations mémoire et la sauvegarde des registres, ainsi que les instructions de saut pour implémenter boucles et appels de fonctions.

Le programme à traduire est le suivant.

```cpp
#include <iostream>
#include <iomanip>

using namespace std;

namespace
{
	const unsigned TailleT = 9;
	unsigned T[] = {1, 3, 5, 2, 9, 8, 6, 4, 7, 0};

	void AfficherTableau (unsigned T[], const unsigned N)
	{
        cout << "T : ";
        for (unsigned i = 0; (i < N); ++i)
        cout << setw(3) << T[i];
        cout << "\n";
	} // AfficherTableau()

	void Swap (unsigned T[], unsigned k)
	{
        unsigned Temp;
        Temp = T[k];
        T[k] = T[k+1];
        T[k+1] = Temp;
	} // Swap()
	
	void Sort (unsigned T[], unsigned N)
	{
        for (unsigned i = 1; (i<N); ++i)
        for (unsigned j = i-1; ((j>=0) && (T[j] > T[j+1])); --j)
        Swap(T, j);
	} // Sort()

} // namespace anonyme

int main ()
{
    AfficherTableau(T, TailleT);
    Sort(T, TailleT);
    AfficherTableau(T,TailleT);
    return 0;
} // main()
```

