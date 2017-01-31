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

