#include <boost/lexical_cast.hpp>
#include <iostream>
#include <string>
#include <cassert>

struct Point {
	int x;
	int y;
};

std::istream &operator>>(std::istream &in, Point &p) {
	char c;
	in >> c;
	assert(c == '(');
	in >> p.x;
	in >> c;
	assert(c == ',');
	in >> p.y;
	in >> c;
	assert(c == ')');
	return in;
}

std::ostream &operator<<(std::ostream &out, const Point &p) {
	out << "(" << p.x << "," << p.y << ")";
	return out;
}

int main() {
	double d = boost::lexical_cast<double>("1.234");
	std::cout << d << std::endl;
	std::string s = boost::lexical_cast<std::string>(d);
	std::cout << s << std::endl;

	// lexical_cast of custom type
	Point p = boost::lexical_cast<Point>("(3,4)");
	std::cout << p.x << " " << p.y << std::endl;
	s = boost::lexical_cast<std::string>(p);
	std::cout << s << std::endl;

	return 0;
}
