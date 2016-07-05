module rip.concepts.mathematics;

private
{
	import std.math;

	import rip.concepts.templates;

	static real RADIAN_IN_DEGREES = 180.0 / PI;
	static real DEGREE_IN_RADIANS = PI / 180.0;
}

// Касинус
/++ +/
T cas(T)(T x)
	if (allArithmetic!T)
{
	auto argument = cast(real) x;
	return cast(T) SQRT2 * cos(x + PI_4);
}


// Ненормированный кардинальный синус
/++ +/
T sinc(T)(T x)
	if (allArithmetic!T)
{
	auto argument = cast(real) x;

	if (approxEqual(x, 0))
	{
		return 1;
	}
	else
	{
		return sin(x) / x;
	}
}

// Нгормированный кардинальный синус
/++ +/
T normalizedSinc(T)(T x)
	if (allArithmetic!T)
{
	auto argument = cast(real) x;

	if (approxEqual(x, 0))
	{
		return 1;
	}
	else
	{
		return sin(PI * x) / (PI * x);
	}
}

/++ +/
T degreesInRadians(T)(T x)
	if (allArithmetic!T)
{
	auto argument = cast(real) x;
	return x * DEGREE_IN_RADIANS;
}

/++ +/
T radiansInDegrees(T)(T x)
	if (allArithmetic!T)
{
	auto argument = cast(real) x;
	return x * RADIAN_IN_DEGREES;
}
