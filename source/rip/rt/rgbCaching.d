module rip.rt.rgbCaching;

version(RgbCachingOn) {

import rip.concepts.color;

RGBManager rgbManager;

static this() {
    rgbManager = new RGBManager(false);
    pragma(msg, "rgbManager is initialized...");
}


}

