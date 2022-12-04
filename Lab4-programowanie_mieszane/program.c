#include <stdio.h>
int dot_product(int tab1[], int tab2[], int n);
int* replace_below_zero(int tab[], int n, int value);

int write_array(int* tab1, int size) {
	printf("[ ");
	for (int i = 0; i < size; i++) {
		printf("%d ", tab1[i]);
	}
	printf("]\n");
}

int main()
{
	int* tab1 = malloc(5 * sizeof(int));
	int* tab2 = malloc(5 * sizeof(int));
	
	/*
	char c;
	printf("\nProsze napisac 5 liczb tab1: ");
	for (int i = 0; i < 5; i++) {
		scanf_s("%d%c", &tab1[i], &c, 12);
		if (c == 10) break;
	}
	printf("\nProsze napisac 5 liczb tab2: ");
	for (int i = 0; i < 5; i++) {
		scanf_s("%d%c", &tab2[i], &c, 12);
		if (c == 10) break;
	}
	*/

	//filling tab1 and tab2
	int j = 4;
	for (int i = 0; i < 5; i++) {
		tab1[i] = i-10;
		tab2[i] = j;
		j--;
	}

	write_array(tab1, 5);
	write_array(tab2, 5);
	printf("\n");

	replace_below_zero(tab1, 5, 10);
	int iloczyn_skalarny = dot_product(tab1, tab2, 5);

	write_array(tab1, 5);
	write_array(tab2, 5);
	printf("Iloczyn skalarny: %d", iloczyn_skalarny);

	return 0;
}