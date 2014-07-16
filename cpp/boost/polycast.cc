#include <boost/cast.hpp>
#include <iostream>

class Base1 { virtual void foo1() {} };
class Base2 { virtual void foo2() {} };
class Base3 { virtual void foo3() {} };
class Derived : public Base1, public Base2 {
	void foo1() {}
	void foo2() {}
};

int main() {
	Base1 *pb1 = new Derived;
	Derived *pd = boost::polymorphic_cast<Derived *>(pb1);
	Base2 *pb2 = boost::polymorphic_cast<Base2 *>(pb1);
	try {
		Base3 *pb3 = boost::polymorphic_cast<Base3 *>(pb1);
	} catch (std::bad_cast &e) {
		std::cout << e.what() << std::endl;
	}
	Base3 *pb3a = dynamic_cast<Base3 *>(pb1);
	std::cout << pb3a << std::endl;
	Base3 &rb3 = dynamic_cast<Base3 &>(*pb1);
	return 0;
}
