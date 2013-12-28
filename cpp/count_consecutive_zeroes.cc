#include <iostream>

int count_consecutive_zeroes(int n) {
	int max = 0;
	int cnt = 0;
	while (n > 0) {
		int digit = n & 1;
		n >>= 1;
		if (digit) {
			if (cnt > max)
				max = cnt;
			cnt = 0;
		} else {
			++cnt;
		}
	}
	return max;
}

int main() {
	std::cout << count_consecutive_zeroes(15) << std::endl;
	return 0;
}