#include <boost/cast.hpp>
#include <limits>

int main() {
	int d = 100;
	char c = boost::numeric_cast<char>(d);
	d = 300;
	//char c1 = boost::numeric_cast<char>(d);
	int max = std::numeric_limits<int>::max();
	//unsigned u = boost::numeric_cast<unsigned>(-1);
	//unsigned char uc = boost::numeric_cast<unsigned char>(256);
	//unsigned u = std::numeric_limits<unsigned>::max();
	//int dd = boost::numeric_cast<int>(u);
	// precision lost is not an error
	//float f = boost::numeric_cast<float>(1.23456789012345);
	//float f = boost::numeric_cast<float>(std::numeric_limits<double>::max());
	unsigned long long ull = boost::numeric_cast<unsigned long long>(1e15);
	std::cout << "OK\n";
	int dd = boost::numeric_cast<int>(1e15);
	return 0;
}
