#include <cstring>
#include <utility>
#include <vector>

class String
{
public:
	String() : base_(NULL), length_(0) {

	}

	String(const String &other) {
		copy_from(other.base_, other.length_);
	}

	String(const char *str) {
		copy_from(str, strlen(str));
	}

	~String() {
		if (length_ > 0) {
			length_ = 0;
			delete[] base_;
		}
	}

	String &operator=(String other) {
		swap(other);
		return *this;
	}

	int length() const {
		return length_;
	}

	const char *c_str() const {
		return base_;
	}

	void swap(String &other) {
		std::swap(other.base_, base_);
		std::swap(other.length_, length_);
	}
private:
	void copy_from(const char *str, int length) {
		length_ = length;
		if (length_ > 0) {
			base_ = new char[length_ + 1];
			strncpy(base_, str, length_);
		} else {
			base_ = NULL;
		}
	}
	char *base_;
	int length_;
};

void foo(String x)
{
}

void bar(const String& x)
{
}

String baz()
{
	String ret("world");
	return ret;
}

int main()
{
	String s0;
	String s1("hello");
	String s2(s0);
	String s3 = s1;
	s2 = s1;

	foo(s1);
	bar(s1);
	foo("temporary");
	bar("temporary");
	String s4 = baz();

	std::vector<String> svec;
	svec.push_back(s0);
	svec.push_back(s1);
	svec.push_back(baz());
	svec.push_back("good job");

	return 0;
}