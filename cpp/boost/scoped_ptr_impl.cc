#include <iostream>

template <class T>
class scoped_ptr
{
public:
	explicit scoped_ptr(T *p = 0)
		: pointer_(p) {	}

	~scoped_ptr()
	{
		// T must be complete type.
		delete pointer_;
	}

	void reset(T *p = 0)
	{
		scoped_ptr<T> tmp(p);
		swap(tmp);
	}

	T &operator*() const
	{
		return *pointer_;
	}

	T *operator->() const
	{
		return pointer_;
	}

	T *get() const
	{
		return pointer_;
	}

	void swap(scoped_ptr &p)
	{
		T *tmp = p.pointer_;
		p.pointer_ = pointer_;
		pointer_ = tmp;
	}

private:
	scoped_ptr(const scoped_ptr &);
	scoped_ptr &operator=(const scoped_ptr &);

	bool operator==(const scoped_ptr &) const;
	bool operator!=(const scoped_ptr &) const;

	T *pointer_;
};

class Foo
{
public:
	Foo()
	{
		std::cout << "Construct\n";
	}

	~Foo()
	{
		std::cout << "Destruct\n";
	}
};

int main()
{
	scoped_ptr<Foo> p(new Foo);
	p.reset(new Foo);

	return 0;
}