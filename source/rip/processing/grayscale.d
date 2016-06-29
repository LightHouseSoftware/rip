module rip.processing.grayscale;

private
{
	import std.algorithm;
	import std.range;

	import rip.concepts.ranges;
	import rip.concepts.templates;
	import rip.concepts.color;
	import rip.concepts.surface;
}

enum GrayPalette
{
	STANDART,
	LUMINANCE,
	AVERAGE
}

class Grayscale {
	GrayPalette palette;

	RGBColor getNewColor(RGBColor a) {
		float intensity;

		final switch (palette) with (GrayPalette)
		{
			case STANDART:
				intensity = 0.2126 * a.red!float + 0.7152 * a.green!float + 0.0722 * a.blue!float;
			break;

			case LUMINANCE:
				intensity = a.luminance!float;
			break;

			case AVERAGE:
				intensity = (a.red!float + a.green!float + a.blue!float) / 3.0;
			break;

		}
		return new RGBColor(intensity, intensity, intensity);
	}

	void 	refColor(ref RGBColor a) {
		a = null;
	}

	this(GrayPalette palette) {
		this.palette = palette;
	}
}

/*auto toGrayScale(Range)(Range r, GrayPalette palette = GrayPalette.STANDART)
	if(isPixelRange!Range)
{
	RGBColor delegate(RGBColor) grayFunction;

	final switch (palette) with (GrayPalette)
	{
		case STANDART:
			grayFunction = delegate(RGBColor color) {
				auto intensity = ((RGBColor color) => 0.2126 * color.red!float + 0.7152 * color.green!float + 0.0722 * color.blue!float);
				return new RGBColor(intensity(color), intensity(color), intensity(color));
			};
			break;

		case LUMINANCE:
			grayFunction = delegate(RGBColor color) {
				auto intensity = color.luminance!float;
				return new RGBColor(intensity, intensity, intensity);
			};
			break;

		case AVERAGE:
			grayFunction = delegate(RGBColor color) {
				auto intensity = (color.red!float + color.green!float + color.blue!float) / 3.0;
				return new RGBColor(intensity, intensity, intensity);
			};
			break;
	}
	auto range = map!(a => grayFunction(a))(r).array;
	return createPixels(range);
}*/

/*auto toGrayScale(Surface surface, GrayPalette palette = GrayPalette.STANDART)
{
	auto image = surface
		.createFences(1,1)
			.map!(a => a.front)
			.toGrayScale(palette)
			.toSurface(surface.getWidth!int, surface.getHeight!int);
	return image;
}*/
