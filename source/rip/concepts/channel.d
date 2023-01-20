module rip.concepts.channel;

private {
    import std.algorithm;
    import std.math;

    import rip.concepts.color;
}

/++
    Class for working with colors on channel level
+/
class Channel {
    float[2]            range;

    /++ +/
    uint                function(in RGBColor color) getValue;

    /++ +/
    RGBColor            function(   in RGBColor color,
                                    in float value) injectValue;

    /++ +/
    this(   float rangeMin, float rangeMax,
            uint function(in RGBColor color) func,
            RGBColor function(in RGBColor color, in float value) colorFunc){

        range[0] = rangeMin;
        range[1] = rangeMax;
        getValue = func;
        injectValue = colorFunc;
    }

    /++ +/
    T getRangeSize(T)() const {
        return cast(T)round(range[1] - range[0] + 1);
    }
}

/++
+/
enum DefaultChannels {

    /++ +/
    Red = new Channel(
        0.0f, 255.0f,
        (in color) => color.red!uint,
        (in color, in value) => new RGBColor(
                value,
                color.green!ubyte,
                color.blue!ubyte)
    ),

    /++ +/
    Green = new Channel(
        0.0f, 255.0f,
        (in color) => color.green!int,
        (in color, in value) => new RGBColor(
                color.red!ubyte,
                value,
                color.blue!ubyte)
    ),

    /++ +/
    Blue = new Channel(
        0.0f, 255.0f,
        (in color) => color.blue!int,
        (in color, in value) => new RGBColor(
                color.red!ubyte,
                color.green!ubyte,
                value)
    ),

    /++ +/
    Grayscale = new Channel(
        0.0f, 255.0f,
        //так-как для построении гистограммы требуется черно-белое изображение,
        //достаточно узнать только значение одного из каналов
        (in color) => color.blue!int,
        (in color, in value) => new RGBColor(
                value, value, value)
    )
}
