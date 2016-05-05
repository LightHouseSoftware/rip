module rip.processing.bitPlane;

private {
    import std.algorithm;
    import std.stdio;

    import rip.concepts;
    import rip.concepts.channel;
}

pure T getBitMask(T)(ubyte bitIndex) {
    //Берём еденицу и сдвигаем её на bitIndex бит влево
    //получаем 2 в степени bitIndex
    return cast(T) (1 << bitIndex);
}

pure T getInvertBitMask(T) (ubyte bitIndex) {
    return ~getBitMask!(T) (bitIndex);
}

bool getBit(T) (T value, ubyte index) {
    return cast(bool)(value & getBitMask!T(index));
}

auto generateBitRange(PixelRange) (PixelRange pixels, Channel channel,
                                    ubyte bitIndex) {
    auto range = pixels
        .map!((a) => channel.getValue(a).getBit(bitIndex));

    return range;
}

auto generateBitRange(Surface surface, Channel channel, ubyte index) {
    return surface
        //FIXME: Не работает через createFences
        .getPixelsRange
        .generateBitRange(channel, index);
}

auto drawBitRange(BitRange)(BitRange range) {
    return range
        .map!(a => a ? new RGBColor(255, 255, 255) : new RGBColor(0, 0, 0));
}

enum BitOperation {
    AND = "&",
    OR = "|",
    NOT = "~",
    XOR = "^"
}

auto cutBitPlane(Range) (Range range, Channel channel, ubyte bitIndex) {
    ubyte mask = getInvertBitMask!ubyte(bitIndex);

    alias appMask = (in color) {
        ubyte value = cast(ubyte)channel.getValue(color);
        ubyte newValue = value & mask;

        return channel.injectValue(color, newValue);
    };

    auto newRange = range
        .map!appMask;

    return newRange;
}

auto injectBitPlane(BitRange, PixelRange) (PixelRange pixels, BitRange bits,
    Channel channel, ubyte bitIndex) {

    alias appMask = (pair) {

        auto color = pair[1];
        ubyte channelValue = cast(ubyte)channel.getValue(color);

        ubyte mask;
        ubyte newValue;
        bool _bit = pair[0];

        if(_bit == true) {
            mask = getBitMask!ubyte(bitIndex);
            newValue = channelValue | mask;
        }
        else {
            mask = getInvertBitMask!ubyte(bitIndex);
            newValue = channelValue & mask;
        }

        return channel.injectValue(color, newValue);
    };

    return zip(bits, pixels).map!appMask;
}

auto processBitPlane(BitOperation op, Range1, Range2)
    (Range1 range1, Range2 range2) {

    mixin(
        "return zip(range1, range2)
            .map!((pair) => pair[0] " ~ op ~" pair[1]);"
    );
}
