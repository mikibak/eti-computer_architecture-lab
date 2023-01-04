#include <stdio.h>
#include <xmmintrin.h>

void pm_jeden(float* tabl);
float find_max_range(float v, float alpha);

float objetosc_stozka(unsigned int big_r, unsigned int small_r, float h);
__m128 szybki_max(short int t1[], short int t2[]);

int write_array_of_shorts(short int* tab, int size) {
	printf("[ ");
	for (int i = 0; i < size; i++) {
		printf("%hd ", tab[i]);
	}
	printf("]\n");
}


int main()
{
	unsigned int big_r0 = 6;
	unsigned int small_r0 = 2;
	float h0 = 5.3f;

	unsigned int big_r1 = 7;
	unsigned int small_r1 = 3;
	float h1 = 4.2f;

	unsigned int big_r2 = 8;
	unsigned int small_r2 = 4;
	float h2 = 6.1f;

	float wynik0 = objetosc_stozka(big_r0, small_r0, h0);
	printf("%f\n", wynik0);

	float wynik1 = objetosc_stozka(big_r1, small_r1, h1);
	printf("%f\n", wynik1);

	float wynik2 = objetosc_stozka(big_r2, small_r2, h2);
	printf("%f\n", wynik2);

	short int val1[8] = { 1, -1, 2, -2, 3, -3, 4, -4 };
	short int val2[8] = { -4, -3, -2, -1, 0, 1, 2, 3 };
	__m128 t1 = szybki_max(val1, val2); // -> t1.m128_i16 = {1, -1, 2, -1, 3, 1, 4, 3}
	write_array_of_shorts(t1.m128_i16, 8);

	return 0;
}