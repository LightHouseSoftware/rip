module rip.processing.convolution;

private
{
	import std.algorithm;
	import std.math;
	import std.range;

	import rip.concepts.color;
	import rip.concepts.ranges;
	import rip.concepts.surface;
	import rip.processing.filters.linear;
}

// Точечная свертка
auto elementaryConvolution(Signal, Filter)(Signal signal, Filter filter)
{

	RGBColor result = new RGBColor(0, 0, 0);

	// Функциональный литерал
	alias conv = (pair)
	{
		if(pair[1] < 0)
		{
			result -= pair[0] * abs(pair[1]);
		}
		else
		{
			result += pair[0] * pair[1];
		}
	};

	foreach (pair; zip(signal, filter)) {
		conv(pair);
	}

	return result;
}

// Свертка сигнала с линейным фильтром
auto convolution(Signal)(Signal signal, LinearFilter filter)
{
	// Выполнение свертки на одном фрагменте диапазона окрестностей
	auto performConvolution(Signal)(Signal signal, LinearFilter filter)
	{
		return filter.getOffset + filter.getDivider * elementaryConvolution(signal, filter.getKernel);
	}

	auto convolutionRange = map!(a => performConvolution(a, filter))(signal).array;
	return convolutionRange;
}

auto convolve(Surface surface, LinearFilter filter)
{
	auto image = surface
		.createFences(filter.getWidth, filter.getHeight)
			.convolution(filter)
			.toSurface(surface.getWidth!int, surface.getHeight!int);
	return image;
}
