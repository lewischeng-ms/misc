#include <boost/utility.hpp>

class no_copy : boost::noncopyable {
};

class no_copy1 : boost::noncopyable {
public:
	no_copy1() {}
	// if no following definition
	// compiler will generate one for you
	// it would automatically call noncopyable::copy_ctor
	// which results in error.
	no_copy1(const no_copy1 &other) {}
};

int main() {
	no_copy1 p11;
	no_copy1 p12(p11);

	/* no_copy p1;
	no_copy p2(p1);
	no_copy p3;
	p3 = p1; */
	return 0;
}
