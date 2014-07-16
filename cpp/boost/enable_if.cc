#include <boost/utility/enable_if.hpp>
#include <boost/type_traits.hpp>
#include <iostream>

template <typename T1, typename T2>
void foo(T1 t1, T2 t2, typename boost::enable_if<boost::is_float<T1> >::type *p = 0) {
	std::cout << "T1 is double\n";
}

template <typename T1, typename T2>
void foo(T1 t1, T2 t2, typename boost::enable_if<boost::is_integral<T1> >::type *p = 0) {
	std::cout << "T1 is integral\n";
}

template <typename T1, typename T2>
void foo(T1 t1, T2 t2, typename boost::disable_if<boost::is_integral<T2> >::type *p = 0) {
	std::cout << "T2 must not be integral\n";
}

template <typename T, typename Enabled = void>
struct Foo {
	void foo() {
		std::cout << "Default\n";
	}
};

// If T is double, then boost::is_float<T> has 'type'
// If T is not float type, then boost::is_float<T> does not have 'type',
// which results in SFIANE. So could only match the above version.
template <typename T>
struct Foo<T, typename boost::enable_if<boost::is_float<T> >::type>
{
	void foo() {
		std::cout << "Double\n";
	}
};

/*template <>
struct Foo<double, void>
{
	void foo() {
		std::cout << "Most specialized version for Double\n";
	}
};*/

int main() {
	int i = 5;
	double d = 1.2;
	foo(i, i);
	foo(d, i);

	// Match the most specialized version.
	Foo<double> f1;
	f1.foo();
	Foo<int> f2;
	f2.foo();
	return 0;
}