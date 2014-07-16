#include <boost/utility.hpp>
#include <cstdio>

struct foolish {
	int operator&() {
		return 0x250;
	}
};

int main() {
	foolish foo;
	printf("%p\n", &foo);
	printf("%p\n", boost::addressof(foo));
	


	printf("%p\n", &((char &)foo));
	return 0;
}