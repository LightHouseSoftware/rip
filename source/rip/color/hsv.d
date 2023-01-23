module rip.color.hsv;

import rip.color.color;
import rip.color.colorSpaceConverter;

class HSVColor : Color!(float, 3) {

    this(float h, float s, float v) {
        super(h, s, v);
    }

    //FIX!
    ColorSpaceConverter.MainColor getMainColor() {
        return new ColorSpaceConverter.MainColor(0, 0, 0);
    }

    //FIX!!
    void fromMainColor(ColorSpaceConverter.MainColor mainColor) {
        data = [0.0f, 0.0f, 0.0f];
    } 
}