module rip.processing.orderFilters.middlePoint;

private {
    import std.algorithm;

    import rip.processing.orderFilters;
    import rip.concepts;
}

class MiddlePointFilter : OrderFilter {
    this(uint width, uint height){
        super(width, height);
    }

    override RGBColor    getValue(RGBColor[] range) {
        return range[0] - range[$ - 1];
    }

    override  bool compare(RGBColor a, RGBColor b) {
        auto luminance1 = a.luminance!float;
		auto luminance2 = b.luminance!float;

		return (luminance1 > luminance2);
    }
}
