#include <stdio.h>
#include <math.h>

#define N_OF_NUMBERS 100000
#define a 69069
#define c 1
#define M 2147483648
#define N_OF_RANGES 10
#define p 7
#define q 3

//long long random(long long previousX) {
//	int X = (a * previousX + c) % M;
//	return X;
//}


int main()
{
	long long X[N_OF_NUMBERS];
	int range[N_OF_RANGES] = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	};

	X[0] = 15;
	for (long long i = 1; i < N_OF_NUMBERS; i++) {
		X[i] = random(X[i - 1]);
		//printf("%d\n", X[i]);
		int index = (N_OF_RANGES * X[i]) / M;
		range[index]++;
	}

	printf("Number of numbers in each range: ");
	for (int i = 0; i < N_OF_RANGES; i++) {
		printf("%d\n", range[i]);
	}


	//2.6
	int bits[32] = { 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	//reset range
	for (int i = 0; i < N_OF_RANGES; i++) {
		range[i] = 0;
	}

	long long result = 0;
	for (int j = 0; j < N_OF_NUMBERS; j++) {
		for (int i = 7; i < 31; i++) {
			int nextBit = bits[i - p] != bits[i - q];
			bits[i] = nextBit;
		}

		//convert bits to an int
		result = 0;
		for (int i = 0; i < 31; i++) {
			result += bits[i] * (long long)pow(2, i);
		}

		X[j] = result;
		int index = (N_OF_RANGES * X[j]) / M;
		range[index]++;

		for (int i = 0; i < 7; i++) {
			bits[i] = bits[i+23];
		}
	}

	printf("\nNumber of numbers in each range: ");
	for (int i = 0; i < N_OF_RANGES; i++) {
		printf("%d\n", range[i]);
	}
}