module rip.parallelism.versionSwitcher;

import std.algorithm;
import rip.parallelism.pmap;

//version = Parallel;

public {
    version(Parallel) {
        alias map = pmap;
    }
    else {
        alias map = std.algorithm.map;
    }

    import std.algorithm : each;
}
