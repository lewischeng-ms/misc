#include <boost/tuple/tuple.hpp>
#include <iostream>
#include <string>

// In the following codes,
// template argument 'Args' represents the actual arguments passed to a lambda expression,
// which are stored in a boost::tuple.

// _1, _2, ... are placeholders.
template <int I> struct placeholder;

// A lambda expression is stored as a lambda functor.
// The 'Base' indicates what the functor is, e.g., a placeholder or an operation?
template <class Base>
class lambda_functor;

// Binary return type:
// When a binary operation takes two types, binary_rt decides the return type.
template <class Args> struct binary_rt;

template <> struct binary_rt<boost::tuple<const int &, const int &> >
{
	typedef int type;
};

template <> struct binary_rt<boost::tuple<const std::string &, const std::string &> >
{
	typedef const std::string type;
};

template <> struct binary_rt<boost::tuple<const double &, const int &> >
{
	typedef double type;
};

// Select:
// Select and return the right argument according to the corresponding placeholder.
template<class Arg, class A, class B>
typename Arg::template sig<boost::tuple<const A &, const B &> >::type
select(const lambda_functor<Arg>& op, const A &a, const B &b)
{ 
	return op.template call<
    	typename Arg::template sig<boost::tuple<const A &, const B &> >::type
	>(a, b);
}

// lambda functor base specialized for 'plus'.
template <class Args>
class lambda_functor_base_for_plus
{
public:
	Args args;
public:
	explicit lambda_functor_base_for_plus(const Args &a) : args(a) {}

	// At least you should tell call() what the return type (RET) is.
	template <class RET, class A, class B>
	RET call(const A &a, const B &b) const
	{
		return select(boost::tuples::get<0>(args), a, b) +
			   select(boost::tuples::get<1>(args), a, b);
	}

	// SigArgs is boost::tuple containing the types of the arguments.
	// sig::type returns the actual type returned if some operation (e.g., here plus)
	// is applied to arguments of these types.
	template<class SigArgs> struct sig
	{
		// Depend on binary_rt's decision.
		typedef typename binary_rt<SigArgs>::type type;
	};
};

// placeholders.
template<> struct placeholder<1>
{
	template<class RET, class A, class B> 
	RET call(const A &a, const B &b) const
	{
		// Return the first argument.
		return a;
	}

	template<class SigArgs> struct sig
	{
		// Return type is the type of the first argument.
		typedef typename boost::tuples::element<0, SigArgs>::type type;
	};
};

template<> struct placeholder<2>
{
	template<class RET, class A, class B> 
	RET call(const A &a, const B &b) const
	{
		// Return the second argument.
		return b;
	}

	template<class SigArgs> struct sig
	{
		// Return type is the type of the second argument.
		typedef typename boost::tuples::element<1, SigArgs>::type type;
	};
};

// lambda functor.
template <class T>
class lambda_functor : public T
{
public:
	typedef T inherited;
public:
	lambda_functor() {}
	lambda_functor(const T& t) : inherited(t) {}

	// When call() is called, the actual calculation is performed in a recursive way.
  	template<class A, class B>
  	typename inherited::template sig<boost::tuple<const A &, const B&> >::type
  	operator()(const A &a, const B &b) const {
    	return inherited::template call<
    		typename inherited::template sig<boost::tuple<const A &, const B&> >::type
    	>(a, b);
  	}
};

// operators reloads.
template<class ArgA, class ArgB>
const lambda_functor<
	lambda_functor_base_for_plus<
		boost::tuple<lambda_functor<ArgA>, lambda_functor<ArgB> >
	>
>
operator+(const lambda_functor<ArgA> &a, const lambda_functor<ArgB> &b)
{
	// Just return the base class of lambda_functor,
	// and 'lambda_functor(const T& t)' will be called.
	return lambda_functor_base_for_plus<
		boost::tuple<lambda_functor<ArgA>, lambda_functor<ArgB> >
	>(boost::tuple<lambda_functor<ArgA>, lambda_functor<ArgB> >(a, b));
}

// free variable definitions.
typedef const lambda_functor<placeholder<1> > placeholder1_type;
typedef const lambda_functor<placeholder<2> > placeholder2_type;

placeholder1_type _1;
placeholder2_type _2;

int main()
{
	std::cout << (_1 + _2)(5, 6) << ", "
			  << (_2 + _1)(std::string("def"), std::string("abc")) << ", "
			  << (_1 + _2)(3.14, 5)
			  << std::endl;

	return 0;
}