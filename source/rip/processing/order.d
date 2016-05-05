module rip.processing.order;

private {
    import std.range;
    import std.algorithm;

    import rip.concepts;
    import rip.processing.orderFilters;
}

/*auto orderFilter(Range) (Range range, OrderFilter filter) {

}*/

auto orderFilter(Surface surface, OrderFilter filter) {
    auto newSurface =
        surface
        .createFences(filter.width, filter.height)
        .map!(a => filter.processFence(a))
        .toSurface(surface.getWidth!uint, surface.getHeight!uint);

    return newSurface;
}
