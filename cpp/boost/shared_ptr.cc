#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>
#include <cstdlib>

using namespace boost;

struct A;
struct B;

struct A {
	char c;
	A() {
		c = 'A';
	}
	~A() {
		if (pb.expired())
			printf("B destroyed\n");
		//else
		//	printf("B::c = %c\n", pb.lock()->c);
		printf("A dtor\n");
	}
	// shared_ptr<B> pb;
	weak_ptr<B> pb;
};

struct B {
	char c;
	B() {
		c = 'B';
	}
	~B() {
		if (pa.expired())
			printf("A destroyed\n");
		else
			printf("A::c = %c\n", pa.lock()->c);
		printf("B dtor\n");
	}
	//shared_ptr<A> pa;
	weak_ptr<A> pa;
};

int main() {
	shared_ptr<A> pa(new A);
	shared_ptr<B> pb(new B);
	pa->pb = pb;
	pb->pa = pa;
	printf("%d, %d\n", pa.use_count(), pb.use_count());
	return 0;
}