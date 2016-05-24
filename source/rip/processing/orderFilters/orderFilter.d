module rip.processing.orderFilters.orderFilter;

private {
    import std.algorithm;
    import std.range;

    import rip.concepts;
}

abstract class OrderFilter {
public:
    uint width, height;

    this(uint width, uint height){
        this.width = width;
        this.height = height;
    }

    RGBColor    getValue(RGBColor[] range);
    bool        compare(RGBColor a, RGBColor b);

    auto    processFence(Range)(Range r) {
        auto sorted =
            r.array
            .sort!((a, b) => compare(a, b))
            .array;

        return getValue(sorted);
    }
}
