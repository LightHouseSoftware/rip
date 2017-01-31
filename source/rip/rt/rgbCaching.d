module rip.rt.rgbCaching;

version(RgbCachingOn) {

    private {
        import rip.color.rgbManager;   
    }

    RGBManager rgbManager;

    static this() {
        rgbManager = new RGBManager(false);
        pragma(msg, "rgbManager is initialized...");
    }
}

auto switchRgbCaching(T)(T args, bool value = true) {
    useRgbCaching = value;
    return args;
} 

void switchRgbCaching(bool value = true) {
    useRgbCaching = value;
} 

shared {
    bool useRgbCaching = false;
}

