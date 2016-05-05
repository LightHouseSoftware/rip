module rip.processing.orderFilters.median;

private {
    import std.algorithm;

    import rip.processing.orderFilters;
    import rip.concepts;
}

class MedianFilter : OrderFilter {
    this(uint width, uint height){
        super(width, height);
    }

    override RGBColor  getValue(RGBColor[] range) {
        return range[(width + height)/2];
    }

    override  bool compare(RGBColor a, RGBColor b) {
        auto luminance1 = a.luminance!float;
		auto luminance2 = b.luminance!float;

		return (luminance1 > luminance2);
    }
}
