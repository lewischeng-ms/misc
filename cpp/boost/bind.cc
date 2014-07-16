// Compile with g++ --std=c++11 f.cc
#include <functional>
#include <iostream>
using namespace std;
using namespace std::placeholders;

int foo(int a, int b) {
	return a + b;
}

int main() {
	function<int (int)> f = bind(foo, 1, _1);
	cout << f(5) << endl;
	return 0;
}