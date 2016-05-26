module rip.analysis.histogram;

private {
    import std.algorithm;
    import std.range;
    import std.math;

    import rip.concepts.color;
    import rip.concepts.surface;
    import rip.concepts.channel;
    import rip.concepts.ranges : toSurface;
}

struct Histogram {
    uint[]   data;

    const Channel channel;

    alias data this;

    this(Channel channel) {
        this.channel = channel;
        data = new uint[channel.getRangeSize!uint()];
    }
}

Histogram takeHistogram(Range)(in Range pixelRange, Channel channel)
        if(isPixelRange!Range)
{
    auto histogram = Histogram(channel);

    pixelRange
//        .getPixels()
        .each!(
            (color) => histogram[ channel.getIndex(color) ]++
        );

    return histogram;
}

//std.algorithm.max не приспособлен для диапазонов
//TODO: убрать это отсюда. Ну позязя :p
T maxValue(T)(T[] args...) {
    T max = args[0];

    foreach(value; args) {
        if(value > max)
            max = value;
    }

    return max;
}

Surface drawHistogram(  Histogram histogram,
                        RGBColor background = new RGBColor(255, 255, 255),
                        RGBColor pencil = new RGBColor(0, 0, 0)) {
    uint width = histogram.channel.getRangeSize!uint;
    uint height = cast(uint)
        (maxValue(histogram.data) / histogram.channel.getRangeSize!float);

    auto surface = new Surface(width, height);

    foreach(i; 0..width) {
        foreach(j; 0..height) {
            if(j <= histogram[i] / histogram.channel.getRangeSize!float()) {
                surface[i, height - j - 1] = pencil;
            }
            else {
                surface[i, height - j - 1] = background;
            }
        }
    }

    return surface;
}

auto  equalizeHistogram(Histogram histogram) {
    Histogram equalizedHistogram = histogram;

    uint pixelsNumber = histogram.data.reduce!"a + b";

    auto probability = histogram
                            .data
                            .map!(( float a)  => a / pixelsNumber)
                            .array;

    int i = 1;
    foreach(ref el; probability[1..$-1]) {
        el += probability[i-1];
        i++;
    }

    uint size = histogram.channel.getRangeSize!uint;

    equalizedHistogram = probability.map!(a => cast(uint)(a * size)).array;
    return equalizedHistogram;
}

Surface appearHistogramToSurface(Histogram histogram, Surface sur) {
    import rip.concepts;

    auto channel = histogram.channel;

    auto getNewColor(in RGBColor color) {
        return channel.injectValue(color, channel.getValue(color));
    }

    return sur
        //функция ниже отзеркаливает картинку по диагонали
        .createFences(1,1)
        .map!(a => a.front)
        .map!getNewColor
        //функция ниже отзеркаливает картинку по диагонали
        .toSurface(sur.getWidth!size_t, sur.getHeight!size_t);
}
