#include <stdio.h>

float srednia_harm(float* tablica, unsigned int n);
float nowy_exp(float x);

int write_array(float* tab, int size) {
	printf("[ ");
	for (int i = 0; i < size; i++) {
		printf("%f ", tab[i]);
	}
	printf("]\n");
}

int main()
{
	int size;
	
	printf("\nProsze wpisaæ rozmiar: ");
	scanf_s("%d", &size, 12);

	float* tab1 = malloc(size * sizeof(float));

	char c;
	printf("\nProsze napisac %d liczb tab1: ", size);
	for (int i = 0; i < 5; i++) {
		scanf_s("%f%c", &tab1[i], &c, 12);
		if (c == 10) break;
	}
	
	float wynik = 0;
	wynik = srednia_harm(tab1, size);

	write_array(tab1, size);
	printf("Wynik: %f", wynik);

	return 0;
}