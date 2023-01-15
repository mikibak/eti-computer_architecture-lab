#include <stdio.h>

int roznica(int* odjemna, int** odjemnik);
int* kopia_tablicy(int tabl[], unsigned int n);
unsigned char iteracja(unsigned char a);
unsigned __int64 sortowanie(unsigned __int64* tabl, unsigned int n);

void write_array(int* tab, int size) {
	printf("[ ");
	for (int i = 0; i < size; i++) {
		printf("%d ", tab[i]);
	}
	printf("]\n");
}

void write_array_64(unsigned __int64* tab, int size) {
	printf("[ ");
	for (int i = 0; i < size; i++) {
		printf("%lld ", tab[i]);
	}
	printf("]\n");
}


int main()
{
	/*int a, b, * wsk, wynik;
	wsk = &b;
	a = 21; b = 25;
	wynik = roznica(&a, &wsk);
	printf("%d\n", wynik);

	int tab1[5] = { 1, 2, 3, 4, 5 };
	int* tab2 = kopia_tablicy(tab1, 5);
	write_array(tab2, 5);

	char w = iteracja(32);
	printf("Znak : %ud", (int)w);*/

	unsigned __int64 tabl[5] = { 5, 4, 2, 1, 3 };
	write_array_64(tabl, 5);
	unsigned __int64 max = sortowanie(tabl, 5);
	write_array_64(tabl, 5);

	printf("%llu ", max);
}