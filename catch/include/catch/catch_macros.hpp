#pragma once

#include <vector>
#include "catch/catch.hpp"

// Additional macros that were handy when migrating unit tests written with xUnit++ originally

inline bool WithinRelativeTolerance(double expected, double actual, double tolerance)
{
	if (expected == 0.0)
		throw std::logic_error("A test on a relative tolerance cannot be on an expected value of zero");
	return (std::abs((expected - actual) / expected) < std::abs(tolerance));
}

#define REQUIRE_EQUAL( expected, actual ) REQUIRE( expected == actual )
#define REQUIRE_EQUAL_COMPARER( expected, actual, comparer) REQUIRE( comparer( expected, actual ) )
#define REQUIRE_NOT_EQUAL( expected, actual ) REQUIRE( expected != actual )
#define REQUIRE_NULL( actual ) REQUIRE( nullptr == actual )
#define REQUIRE_NOT_NULL( actual ) REQUIRE( nullptr != actual )
#define REQUIRE_THROWS_EXCEPTION_TYPE(exceptionType, expr) REQUIRE_THROWS_AS( expr, exceptionType)
#define REQUIRE_WITHIN_ABSOLUTE_TOLERANCE( expected, actual, delta) REQUIRE( (abs(expected - actual) < delta) )
#define REQUIRE_WITHIN_RELATIVE_TOLERANCE( expected, actual, delta) REQUIRE( WithinRelativeTolerance(expected, actual, delta) )

using std::vector;

// Test vector equality - no known better way to do this with Catch 1.5.6
template<typename T>
void AssertVectorsEqual(const vector<T>& expected, const vector<T>& actual, T tolerance = -1, bool relative = false)
{
	//Note that Catch v2 may be able to offer the following (seems not to work for Catch v1.5.6)
	//std::vector<int> values{ 1, 2, 3 };
	//REQUIRE_THAT(values, Catch::Equals<int>({ 1, 2, 3 }));
	REQUIRE(expected.size() == actual.size());
	for (size_t i = 0; i < expected.size(); i++)
	{
		if (tolerance < 0)
		{
			if (expected[i] != actual[i])
				FAIL("Vectors elements differ at index " + std::to_string(i));
		}
		else
		{
			if (relative)
			{
				if (!WithinRelativeTolerance(expected[i], actual[i], tolerance))
					FAIL("Vectors elements not within relative tolerance at index " + std::to_string(i));
			}
			else
				if (!(std::abs(expected[i] - actual[i]) < tolerance))
					FAIL("Vectors elements not within absolute tolerance at index " + std::to_string(i));
		}
	}
}
