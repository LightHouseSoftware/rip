module rip.processing.negative;

private
{
	import std.algorithm;
	import std.range;
	import std.stdio;

	import rip.concepts.ranges;
	import rip.concepts.templates;
	import rip.concepts.color;
	import rip.concepts.surface;

	import rip.concepts.destination;
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

auto toNegativeNew(Range)(Range r, RGBColor color = new RGBColor(255, 255, 255))
	if(isPixelRange!Range)
{
	return r.map!(a => color - a);
}


auto toNegativeNew(Surface surface, RGBColor color = new RGBColor(255, 255, 255))
{
	auto image = surface
		//использовать следует только ленивую версию createFences
		.createFencesNew(1,1)
			//a.base возвращает главный пиксель, окрестность которого исследуем
			.map!(a => a.base)
			//опять же используем ленивость
			.toNegativeNew(color)
			//передаём всю поверхность целиком.
			//новая версия сама создаст новую из параметров старой
			.toSurface(surface);
	return image;
}
