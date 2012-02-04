#include <stdio.h>

unsigned crc(unsigned data, unsigned gen, unsigned n)
{
	unsigned m = n - 1;
	unsigned o = 1 << 31;
	unsigned p = 32 - n;
	unsigned q = (1 << m) - 1;

	unsigned divd = data << m;
	unsigned divr = gen << p;
	int i;
	for (i = 0; i < p; ++i)
	{
		if (divd & o) divd ^= divr;
		divr >>= 1;
		o >>= 1;
	}

	return (data << m) | (divd & q);
}

int main()
{
	unsigned data = 0x53A1; // 0101 0011 1010 0001b
	unsigned gen = 0x1D5; // crc-8: 0001 1101 0101b
	unsigned n = 9;
	printf("%X\n", crc(data, gen, n)); // Should be 0x53A18C
	return 0;
}
