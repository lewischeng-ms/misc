#include <unordered_map>
#include <vector>
#include <algorithm>
#include <functional>
#include <limits>
#include <iostream>

using namespace std;

const double kDiscount[5] = {
	0.00,
	0.05,
	0.10,
	0.20,
	0.25
};

const double kUnitPrice = 8.0;

const vector<int> kNone(5, 0);

double F(vector<int> &quantity) {
	if (quantity == kNone)
		return 0.0;

	sort(quantity.begin(), quantity.end(), greater<int>());

	double min_price = numeric_limits<double>::max();

	if (quantity[4] >= 1) {
		vector<int> arg(5, 0);
		arg[4] = quantity[4] - 1;
		arg[3] = quantity[3] - 1;
		arg[2] = quantity[2] - 1;
		arg[1] = quantity[1] - 1;
		arg[0] = quantity[0] - 1;
		min_price = 5 * kUnitPrice * (1 - kDiscount[4]) + F(arg);
	}

	if (quantity[3] >= 1) {
		vector<int> arg(5, 0);
		arg[4] = quantity[4];
		arg[3] = quantity[3] - 1;
		arg[2] = quantity[2] - 1;
		arg[1] = quantity[1] - 1;
		arg[0] = quantity[0] - 1;
		double result = 4 * kUnitPrice * (1 - kDiscount[3]) + F(arg);
		min_price = min(min_price, result);
	}

	if (quantity[2] >= 1) {
		vector<int> arg(5, 0);
		arg[4] = quantity[4];
		arg[3] = quantity[3];
		arg[2] = quantity[2] - 1;
		arg[1] = quantity[1] - 1;
		arg[0] = quantity[0] - 1;
		double result = 3 * kUnitPrice * (1 - kDiscount[2]) + F(arg);
		min_price = min(min_price, result);
	}

	if (quantity[1] >= 1) {
		vector<int> arg(5, 0);
		arg[4] = quantity[4];
		arg[3] = quantity[3];
		arg[2] = quantity[2];
		arg[1] = quantity[1] - 1;
		arg[0] = quantity[0] - 1;
		double result = 2 * kUnitPrice * (1 - kDiscount[1]) + F(arg);
		min_price = min(min_price, result);
	}

	if (quantity[0] >= 1) {
		vector<int> arg(5, 0);
		arg[4] = quantity[4];
		arg[3] = quantity[3];
		arg[2] = quantity[2];
		arg[1] = quantity[1];
		arg[0] = quantity[0] - 1;
		double result = 1 * kUnitPrice * (1 - kDiscount[0]) + F(arg);
		min_price = min(min_price, result);
	}

	return min_price;
}

int main() {
	vector<int> quantity(5);
	quantity[0] = 2;
	quantity[1] = 2;
	quantity[2] = 2;
	quantity[3] = 1;
	quantity[4] = 1;
	cout << F(quantity) << endl;
	return 0;
}