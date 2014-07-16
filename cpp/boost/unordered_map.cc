#include <boost/unordered_map.hpp>
#include <boost/foreach.hpp>
#include <string>
#include <iostream>

int main()
{
	// An unordered map is a hash table.
	typedef boost::unordered_map<std::string, int> map_type;
	map_type x;

	// Insert mapping through operator[].
	x["one"] = 1;
	x["two"] = 2;
	x["three"] = 3;
	

	// Though insert().
	x.insert(map_type::value_type("six", 6));

	// Here value_type is a std::pair.
	BOOST_FOREACH (map_type::value_type i, x)
		std::cout << i.first << ", " << i.second << std::endl;

	// at() will cause exception if not found.
	try {
		std::cout << x.at("four") << std::endl;
	} catch (std::out_of_range &e) {
		std::cout << "four not found" << std::endl;
	}
	
	// operator[] will automatically create a new pair for a non-existing key.
	std::cout << x["five"] << std::endl;

	std::cout << (x.find("three") == x.end()) << std::endl;

	// Can erase a mapping using an iterator or a key.
	auto iter = x.find("three");
	x.erase(iter);
	x.erase("two");

	return 0;
}
