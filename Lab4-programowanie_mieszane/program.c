#include <stdio.h>

float srednia_harm(float* tablica, unsigned int n);
float nowy_exp(float x);
float y_do_x(float y, float x);
char* suma_tablic_charow(char liczby_A[], char liczby_B[], char* liczby_suma);
void int2float(int* calkowite, float* zmienno_przec);
void pm_jeden(float* tabl);

int write_array(float* tab, int size) {
	printf("[ ");
	for (int i = 0; i < size; i++) {
		printf("%f ", tab[i]);
	}
	printf("]\n");
}

int main()
{
	/*
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
	*/

	/*
	//y do x
	float x = 3.0f;
	float y = 2.0f;

	float potega = y_do_x(y, x);
	printf("Potega: %f", potega);
	*/

	/*
	//5.3 suma charów
	char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122,
		-121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3,
		3, 3, 3, 3, 3, 3, 3, 3 };
	char* liczby_suma = malloc(16 * sizeof(char));
	suma_tablic_charow(liczby_A, liczby_B, liczby_suma);

	printf("[ ");
	for (int i = 0; i < 16; i++) {
		printf("%d ", (int)liczby_suma[i]);
	}
	printf("]\n");
	*/

	/*
	//5.4 int to float
	int a[2] = { -17, 24 };
	float r[4];
	// podany rozkaz zapisuje w pamiêci od razu 128 bitów,
	// wiêc musz¹ byæ 4 elementy w tablicy
	int2float(a, r);
	printf("\nKonwersja = %f %f\n", r[0], r[1]);
	*/

	/*
	//5.5 
	float tablica[4] = { 27.5,143.57,2100.0, -3.51 };
	printf("\n%f %f %f %f\n", tablica[0],
		tablica[1], tablica[2], tablica[3]);
	pm_jeden(tablica);
	printf("\n%f %f %f %f\n", tablica[0],
		tablica[1], tablica[2], tablica[3]);
	*/

	return 0;
}