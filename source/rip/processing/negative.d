module rip.processing.negative;

private
{
	import std.algorithm;
	import std.range;

	import rip.concepts.ranges;
	import rip.concepts.color;
	import rip.concepts.surface;
}

auto toNegative(Range)(Range r, RGBColor color = new RGBColor(255, 255, 255))
	if(isPixelRange!Range)
{
	auto range = map!(a => color - a)(r).array;
	return createPixels(range);
}


auto toNegative(Surface surface, RGBColor color = new RGBColor(255, 255, 255))
{
	auto image = surface
		.createFences(1,1)
			.map!(a => a.front)
			.toNegative(color)
			.toSurface(surface.getWidth!int, surface.getHeight!int);
	return image;
}
