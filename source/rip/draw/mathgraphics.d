module rip.draw.mathgraphics;

private
{
	import std.algorithm;
	import std.math;
	import std.range;
	import std.traits;

	import rip.concepts;

	import rip.draw.primitives : drawPoint;

	// отрисовка по сразу двум параметрам-диапазонам
	// не предназначена для внешнего использования
	auto drawTwoRanges(First, Second)(Surface surface, RGBColor rgbColor,
		First first, Second second)
		if (allArithmetic!(ElementType!First, ElementType!Second))
	{
		assert(!first.empty);
		assert(!second.empty);

		foreach (xy; zip(first, second))
		{
			surface.drawPoint(rgbColor, xy[0], xy[1]);
		}
	}
}

alias drawDiscrete = drawTwoRanges; // рисование последовательностей

// график некоторой функции на непрерывном диапазоне
auto drawFunctional(T, U, Range)(Surface surface, RGBColor rgbColor,
	T delegate(U) func, Range r)
	if (isInputRange!(Unqual!Range) && allArithmetic!(T, U, ElementType!Range))
{
	assert(!r.empty);

	auto ys = map!(a => func(a))(r);

	drawTwoRanges(surface, rgbColor, r, ys);
}


// график параметрической функции
auto drawParametrical(T, U, V, W, Range)(Surface surface, RGBColor rgbColor,
	T delegate(U) funcX, V delegate(W) funcY, Range r)
	if (isInputRange!(Unqual!Range) && allArithmetic!(T, U, V, W, ElementType!Range))
{

	auto xs = map!(a => funcX(a))(r);
	auto ys = map!(a => funcY(a))(r);

	drawTwoRanges(surface, rgbColor, xs, ys);
}


// рисование функции в полярных координатах (углы в градусах)
auto drawPolarInDegrees(T, U, Range)(Surface surface, RGBColor rgbColor,
	T delegate(U) func, Range r)
	if (isInputRange!(Unqual!Range) && allArithmetic!(T, U, ElementType!Range))
{
	assert(!r.empty);

	auto phi = map!(a => a * (PI / 180.0))(r).array;
	auto xs = map!(a => func(a) * cos(a))(phi);
	auto ys = map!(a => func(a) * sin(a))(a);

	drawTwoRanges(surface, rgbColor, r, ys);
}


// рисование функции в полярных координатах (углы в радианах)
auto drawPolarInRadians(T, U, Range)(Surface surface, RGBColor rgbColor,
	T delegate(U) func, Range r)
	if (isInputRange!(Unqual!Range) && allArithmetic!(T, U, ElementType!Range))
{
	assert(!r.empty);

	auto xs = map!(a => func(a) * cos(a))(r);
	auto ys = map!(a => func(a) * sin(a))(r);

	drawTwoRanges(surface, rgbColor, r, ys);
}
