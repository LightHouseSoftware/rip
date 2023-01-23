module rip.color.colorSpaceConverter;
import rip.color.rgb;

static class ColorSpaceConverter {
    static public alias MainColor = RGBColor;

    public static auto convertToMainColor(F)(F from)
      if(translatableToMainColor!F)    
    {
        return from.getMainColor();
    }

    public static auto convert(F, T)(F from) {
        auto newMainColor = from.getMainColor();
        auto newT = new T(0, 0, 0, 0);
        newT.fromMainColor(newMainColor);
        return newT;
    }
}

template translatableToMainColor(T) {
    enum hasGetMainColorMamber = __traits(hasMember, T, "getMainColor");
    enum hasFromMainColorMamber = __traits(hasMember, T, "fromMainColor");

    enum bool translatableToMainColor = hasFromMainColorMamber && hasGetMainColorMamber;
}