module rip.processing.orderFilters.maximum;

private {
    import std.algorithm;

    import rip.processing.orderFilters;
    import rip.concepts;
}

class MaximumFilter : OrderFilter {
    this(uint width, uint height){
        super(width, height);
    }

    override RGBColor getValue(RGBColor[] colors) {
        return colors[width * height - 1];
    }

    override  bool compare(RGBColor a, RGBColor b) {
        auto luminance1 = a.luminance!float;
		auto luminance2 = b.luminance!float;

		return (luminance1 < luminance2);
    }
}
