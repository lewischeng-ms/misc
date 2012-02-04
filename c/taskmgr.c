#include <windows.h>
#include <math.h>

#define INTERVAL 500
#define HALF 250
#define COUNT 50
#define PI2 (3.14159f * 2)

int busy[COUNT];
int idle[COUNT];

int main()
{
	int i;
	for (i = 0; i <= COUNT; i++)
	{
		busy[i] = (sin(PI2 * ((float)i / COUNT)) + 1) * HALF;
		idle[i] = INTERVAL - busy[i];
	}
	int start;
	while (1)
	{
		for (i = 0; i < COUNT; i++)
		{
			start = GetTickCount();
			while (GetTickCount() - start < busy[i]);
			Sleep(idle[i]);
		}
	}
	return 0;
}