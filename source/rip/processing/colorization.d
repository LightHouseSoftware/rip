module rip.processing.colorization;

private
{
	import std.algorithm;
	import std.range;

	import rip.concepts.ranges;
	import rip.concepts.color;
	import rip.concepts.surface;
}

auto compareColors(RGBColor a, RGBColor b)
{
	return a.distance!float(b);
}

// выборочная замена цвета (впоследстивие можно обобщить)
auto selectiveReplacing(Range)(Range r, RGBColor color, float detalizationLevel)
	if(isPixelRange!Range)
{
	// процедура замены цвета
	auto replacingProcedure(RGBColor a, RGBColor b)
	{
		if (compareColors(a, b) <= detalizationLevel)
		{
			return a;
		}
		else
		{
			auto I = 0.2126 * a.red!float + 0.7152 * a.green!float + 0.0722 * a.blue!float;
			return new RGBColor(I, I, I);
		}
	}

	auto range = map!(a => replacingProcedure(a, color))(r).array;
	return createPixels(range);
}


// замена цвета на другой
auto colorReplacing(Range)(Range r, RGBColor color, float detalizationLevel)
	if(isPixelRange!Range)
{
	// процедура замены цвета
	auto replacingProcedure(RGBColor a, RGBColor b)
	{
		if (compareColors(a, b) <= detalizationLevel)
		{
			return b;
		}
		else
		{
			return a;
		}
	}

	auto range = map!(a => replacingProcedure(a, color))(r).array;
	return createPixels(range);
}

// простая замена одного цвета другим
auto simpleColorizing(Surface surface, RGBColor color, float detalizationLevel)
{
	auto image = surface
		.createFences(1,1)
			.map!(a => a.front)
			.colorReplacing(color, detalizationLevel)
			.toSurface(surface.getWidth!int, surface.getHeight!int);
	return image;
}

// выборочное обесцвечивание
auto selectiveColorizing(Surface surface, RGBColor color, float detalizationLevel)
{
	auto image = surface
		.createFences(1,1)
			.map!(a => a.front)
			.selectiveReplacing(color, detalizationLevel)
			.toSurface(surface.getWidth!int, surface.getHeight!int);
	return image;
}
