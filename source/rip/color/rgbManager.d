module rip.color.rgbManager;

private {
    import std.algorithm;
    
    import rip.color.rgb;
}

class RGBManager {
	RGBColor[][][] cache;
	int cached;
	bool fullInitialization;

	this(bool fullInitialization = false) {
		cache.length = 256;

		this.fullInitialization = fullInitialization;

		//Danger!!! FIX IT 
		if(fullInitialization)
			initizalizeFullSpace();
	}

	void initizalizeFullSpace() {
		foreach(ref _array; cache) {
			_array.length = 256;
			foreach(ref __array; _array) {
				__array.length = 256;
			}
		}
	}

	private bool freeColorPlace(T, U, V)(T red, U green, V blue) {
		if(!fullInitialization) {
			if(cache[red].length == 0)
				cache[red].length = 256;
			
			if(cache[red][green].length == 0)
				cache[red][green].length = 256;
		}
		
		if(cache[red][green][blue] !is null)
			return false;

		return true;
	}

	public RGBColor getColor(T, U, V)(T _red, U _green, V _blue) {
		ubyte red = cast(ubyte) clamp(_red, cast(ubyte)0, cast(ubyte)255);
		ubyte green = cast(ubyte) clamp(_green, cast(ubyte)0, cast(ubyte)255);
		ubyte blue = cast(ubyte) clamp(_blue, cast(ubyte)0, cast(ubyte)255);

		bool initialized = this.freeColorPlace(red, green, blue);

		if(initialized) {
			cache[red][green][blue] = new RGBColor(red, green, blue);
			cached++;
		}

		return cache[red][green][blue];
	}

	public RGBColor getColor(RGBColor color) {
		ubyte red = color.red!ubyte;
		ubyte green = color.green!ubyte;
		ubyte blue = color.blue!ubyte;

		return this.getColor(red, green, blue);
	}

	// public bool putColor(RGBColor color) {
	// 	ubyte red = color.red!ubyte;
	// 	ubyte green = color.green!ubyte;
	// 	ubyte blue = color.blue!ubyte;
		
	// 	if(freeColorPlace(red, green, blue)) {
	// 		cache[red][green][blue] = new RGBColor(red, green, blue);
	// 		return true;
	// 	}
	// 	else
	// 		return false;
	// }

	public int getCached() {
		return cached;
	} 
}
