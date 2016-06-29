module rip.concepts.elementaryOperations;

import rip.concepts;
import std.algorithm;
import rip.concepts.destination;

auto atomary(Op, Range)(Range source)
if(isPixelRange!Range) {
    Op op = new Op;

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

Surface atomary(Op) (Surface sur) {
    auto result = sur
        .createFencesNew(1, 1)
        .map!(a => a.base)
        .atomary!Op
        ;

    if(destination == Destination.Source)
        return sur;
    else
        return result.toSurface(sur);
}
