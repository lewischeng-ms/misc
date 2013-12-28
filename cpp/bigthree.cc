// dtor, copy-ctor and copy-operator
// if one of the three defined,
// you must define the other two.

class sample {
public:
	sample()
		: value_(new int(8)) { }
	
	sample(const sample &other)
		: value_(new int(*other.value_)) { }

	sample &operator=(const sample &other) {
		*value_ = *other.value_;
		return *this;
	}

	~sample() {
		delete value_;
	}

private:
	int *value_;
};

int main() {
	sample s1;
	sample s2(s1);
	sample s3;
	s3 = s1;
	return 0;
}
