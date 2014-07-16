#include <boost/type_traits.hpp>
#include <boost/static_assert.hpp>

#define ASSERT_IS_INTEGRAL(T) BOOST_STATIC_ASSERT(boost::is_integral<T>::value)

int main() {
	BOOST_STATIC_ASSERT(sizeof(int) == 4);
	ASSERT_IS_INTEGRAL(int);
	ASSERT_IS_INTEGRAL(double);
	return 0;
}
