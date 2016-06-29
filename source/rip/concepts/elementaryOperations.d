module rip.concepts.elementaryOperations;

import rip.concepts;
import std.algorithm;
import rip.concepts.destination;
import std.stdio;

auto atomary(Op, Range, Args...)(Range source, Args args)
if(isPixelRange!Range) {
    auto op = new Op(args);

    if(destination == Destination.Source) {
        source.each!(a => op.refColor(a));

        return null;
    }
    else {
        RGBColor[] data;

        foreach(pix; source) {
            data ~= op.getNewColor(pix);
        }

        return data;
    }

}

Surface atomary(Op, Args...) (Surface sur, Args args) {
    auto result = sur
        .createFencesNew(1, 1)
        .map!(a => a.base)
        .atomary!Op(args);

    if(destination == Destination.Source)
        return sur;
    else
        return result.toSurface(sur);
}
