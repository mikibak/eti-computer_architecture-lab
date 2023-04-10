#include <stdio.h>
//int dot_product(int tab1[], int tab2[], int n);
//int* replace_below_zero(int tab[], int n, int value);
int mse_loss(int tab1[], int tab2[], int n);
int* merge_reversed(int tab1[], int tab2[], int n);

int write_array(int* tab, int size) {
	printf("[ ");
	for (int i = 0; i < size; i++) {
		printf("%d ", tab[i]);
	}
	printf("]\n");
}

int main()
{
	int size;
	
	
	printf("\nProsze wpisać rozmiar: ");
	scanf_s("%d", &size, 12);

	int* tab1 = malloc(size * sizeof(int));
	int* tab2 = malloc(size * sizeof(int));
	int* tablica_zlaczona = malloc(size * 2 *sizeof(int));

	char c;
	printf("\nProsze napisac %d liczb tab1: ", size);
	for (int i = 0; i < 5; i++) {
		scanf_s("%d%c", &tab1[i], &c, 12);
		if (c == 10) break;
	}
	printf("\nProsze napisac %d liczb tab2: ", size);
	for (int i = 0; i < 5; i++) {
		scanf_s("%d%c", &tab2[i], &c, 12);
		if (c == 10) break;
	}
	
	int wynik = 0;
	wynik = mse_loss(tab1, tab2, size);

	//filling tab1 and tab2
	/*
	int j = 4;
	for (int i = 0; i < 5; i++) {
		tab1[i] = i-10;
		tab2[i] = j;
		j--;
	}
	*/

	/*
	write_array(tab1, 5);
	write_array(tab2, 5);
	printf("\n");
	
	replace_below_zero(tab1, 5, 10);
	int iloczyn_skalarny = dot_product(tab1, tab2, 5);
	*/

	tablica_zlaczona = merge_reversed(tab1, tab2, size);

	write_array(tab1, size);
	write_array(tab2, size);
	write_array(tablica_zlaczona, size*2);
	printf("Wynik: %d", wynik);

	return 0;
}