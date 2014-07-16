#include <iostream>
#include <cassert>

// Responsible for reference counting but not deleting object.
class sp_counted_base
{
public:
	sp_counted_base() : use_count_(1)
	{

	}

	virtual ~sp_counted_base()
	{

	}

	virtual void dispose() = 0;

	void add_ref_copy()
	{
		// In boost, BOOST_INTERLOCKED_INCREMENT is used, so boost::shared_ptr is thread-safe.
		++use_count_;
	}

	void release()
	{
		if (--use_count_ == 0)
			dispose();
	}

	long use_count()
	{
		return use_count_;
	}

private:
	long use_count_;
};

// Specialize pointer type X and dispose().
template <class X>
class sp_counted_impl_p : public sp_counted_base
{
public:
	explicit sp_counted_impl_p(X *px): px_(px)
	{

	}

	void dispose()
	{
		delete px_;
	}

private:
	X *px_;
};

// This class knows when to call add_ref_copy() and release().
class shared_count
{
public:
	shared_count() : pi_(0)
	{

	}

	template <class Y>
	explicit shared_count(Y *p)
	{
		// Store raw pointer in a type-safe way.
		// This is why even when base class's dtor is not declared virtual,
		// but sub class's dtor would still be called.
		pi_ = new sp_counted_impl_p<Y>(p);
	}

	shared_count(const shared_count &rhs) : pi_(rhs.pi_)
	{
		pi_->add_ref_copy();
	}

	~shared_count()
	{
		if (pi_)
			pi_->release();
	}

	void swap(shared_count &rhs)
	{
		std::swap(pi_, rhs.pi_);
	}

	long use_count() const
	{
		return pi_->use_count();
	}

private:
	sp_counted_base *pi_;
};

template <class T>
class shared_ptr
{
public:
	shared_ptr() : px(0), pn()
	{

	}

	template <class Y>
	explicit shared_ptr(Y *p) : px(p), pn()
	{
		shared_count temp(p);
		pn.swap(temp);
	}

	shared_ptr(const shared_ptr &rhs) : px(rhs.px), pn(rhs.pn)
	{

	}

	shared_ptr &operator=(const shared_ptr &rhs)
	{
		shared_ptr temp(rhs);
		swap(temp);
		return *this;
	}

	template <class Y>
	void reset(Y *p)
	{
		shared_ptr temp(p);
		swap(temp);
	}

	T operator*() const
	{
		return *px;
	}

	T *operator->() const
	{
		return px;
	}

	T *get() const
	{
		return px;
	}

	long use_count() const
	{
		return pn.use_count();
	}

	void swap(shared_ptr & rhs)
    {
        std::swap(px, rhs.px);
        pn.swap(rhs.pn);
    }

private:
	// pn and px are paired.
	// And in pn, px is stored as its actual pointer type (maybe sub class of T).
	T *px;
	shared_count pn;
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
	shared_ptr<Foo> p(new Foo);
	assert(p.use_count() == 1);

	shared_ptr<Foo> p1(p);
	assert(p1.use_count() == 2);

	shared_ptr<Foo> p2;
	p2 = p;
	assert(p2.use_count() == 3);

	return 0;
}