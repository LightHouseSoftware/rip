module rip.color.cmyk;

import rip.color.color;
import rip.color.colorSpaceConverter;

class CMYKColor : Color!(float, 4) {
    this(float c, float m, float y, float k) {
        super(c, m, y, k);
    }

    //FIX!!
    ColorSpaceConverter.MainColor getMainColor() {

        return new ColorSpaceConverter.MainColor(0, 0, 0);
    }

    //FIX!!
    void fromMainColor(ColorSpaceConverter.MainColor mainColor) {
        data = [0.0f, 0.0f, 0.0f, 0.0f];
    } 
}