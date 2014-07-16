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
	Derived *pd = new Derived;
	Base2 *pb2 = boost::polymorphic_downcast<Base2 *>(pd);
#	ifndef NDEBUG
	Base3 *pb3 = boost::polymorphic_downcast<Base3 *>(pd);
#	endif
	return 0;
}
