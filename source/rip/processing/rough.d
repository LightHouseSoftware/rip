module rip.processing.rough;

private
{
	import std.algorithm;
	import std.math;
	import std.range;

	import rip.concepts;
}

auto roughPixels(Range, T)(Range r, T numberOfColor)
	if (isPixelRange!Range)
{
	auto N = cast(ushort) abs(numberOfColor);
	RGBColor delegate(RGBColor) roughFunction = delegate(RGBColor color)
	{
		// assert((0 < numberOfColor) && (numberOfColor <= 255));

		auto R = color.red!float;
		auto G = color.green!float;
		auto B = color.blue!float;

		return new RGBColor(R %= N, G %= N, B %= N);
	};

	auto range = map!(a => roughFunction(a))(r).array;
	return createPixels(range);
}

// огрубление (т.е срезание диапазона присутствующих цветов и их оттенков)
auto toRough(T)(Surface surface, T numberOfColors)
{
	auto N = cast(ushort) abs(numberOfColors);
	auto image = surface
		.createFences(1,1)
			.map!(a => a.front)
			.roughPixels(numberOfColors)
			.toSurface(surface.getWidth!int, surface.getHeight!int);
	return image;
}
