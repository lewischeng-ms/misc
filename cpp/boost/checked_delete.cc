#include <boost/checked_delete.hpp>
#include <cstdlib>

class T1;

class T2 {};

int main() {
	T1 *p1 = NULL;
	T2 *p2 = NULL;
	boost::checked_delete(p1);
	boost::checked_delete(p2);
	return 0;
}
