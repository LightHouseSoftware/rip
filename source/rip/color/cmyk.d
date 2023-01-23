module rip.color.cmyk;

import rip.color.color;
import rip.color.colorSpaceConverter;
import std.algorithm;
import std.format;

class CMYKColor : Color!(float, 4) {
    this(float c = 0, float m = 0, float y = 0, float k = 0) {
        super(c, m, y, k);
    }

    ColorSpaceConverter.MainColor getMainColor() {
        ubyte r = cast(ubyte)(255 * (1 - data[0]) * (1 - data[3]));
        ubyte g = cast(ubyte)(255 * (1 - data[1]) * (1 - data[3]));
        ubyte b = cast(ubyte)(255 * (1 - data[2]) * (1 - data[3]));

        return new ColorSpaceConverter.MainColor(r, g, b);
    }

    void fromMainColor(ColorSpaceConverter.MainColor mainColor) {
        float _r = mainColor.red!float / 255.0f;
        float _g = mainColor.green!float / 255.0f;
        float _b = mainColor.blue!float / 255.0f;

        float k = 1 - max(_r, _g, _b);
        float c = (1 - _r - k) / (1 - k);
        float m = (1 - _g - k) / (1 - k);
        float y = (1 - _b - k) / (1 - k);

        data = [c, m, y, k];
    } 

	override string toString() const
	{
		return format("CMYK(%f, %f, %f, %f)", data[0], data[1], data[2], data[3]);
	}
}