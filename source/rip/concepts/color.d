module rip.concepts.color;

private
{
	import std.algorithm : clamp;
	import std.math;
	import std.string;

	import rip.concepts.templates;
	import rip.rt.rgbCaching;
}

//delete 
version(RgbCachingOn) {
	private alias manager = rgbManager;
}

/++
	Digital implementation of RGB color format.
+/
class RGBColor
{
	private
	{
		// Является ли бинарная операция основной ?
		static bool isGeneralOperation(string op)
		{
			switch (op)
			{
				case "+", "-", "*", "/", "%", "^^":
					return true;
				default:
					return false;
			}
		}
	}

	protected
	{
		ubyte R;
		ubyte G;
		ubyte B;

		// Задание компонент цвета
		void setChannels (T, U, V)(T red, U green, V blue)
			if (allArithmetic!(T, U, V))
		{
			this.R = cast(ubyte) clamp(red, 0, 255);
			this.G = cast(ubyte) clamp(green, 0, 255);
			this.B = cast(ubyte) clamp(blue, 0, 255);
		}
	}

	/++
	+	Parametrized ctor for working with any arithmetic types
	+   Params:
	+     	red 		= red componemt
	+    	green 		= green componemt
	+	 	blue 		= blue componemt
	+/
	this(T, U, V)(T red, U green, V blue)
		if (allArithmetic!(T, U, V))
	{
		setChannels(red, green, blue);
	}

	public static RGBColor getColor(T, U, V)(T red, U green, V blue) {
		version(RgbCachingOn) {
			return manager.getColor(red, green, blue);
		}
		else
			return new RGBColor(red, green, blue);
	}

	public static RGBColor getColor(RGBColor color) {
		version(RgbCachingOn) {
			return manager.getColor(color);
		}
		//USELESS
		else
			return color;
	}

	/++
		Mixins for typed getter
	+/
	mixin(addTypedGetter!("R", "red"));

	/++ ditto +/
	mixin(addTypedGetter!("G", "green"));

	/++ ditto +/
	mixin(addTypedGetter!("B", "blue"));

	/++ ditto +/
	mixin(addTypedGetter!("0.3f * R + 0.59f * G + 0.11f * B", "luminance"));

	/++
		Funcs for changing components of color
	+/
	void setRed(T)(T red)
	{
		setChannels(red, G, B);
	}

	/++ ditto +/
	void setGreen(T)(T green)
	{
		setChannels(R, green, B);
	}

	/++ ditto +/
	void setBlue(T)(T blue)
	{
		setChannels(R, G, blue);
	}

	/++
		Params:
			rhs  	= second color
		Returns:
			Distance between two colors in RGB space
	+/
	T distance(T)(RGBColor rhs)
	{
		auto dRed = (this.red!float - rhs.red!float) ^^ 2;
		auto dGreen = (this.green!float - rhs.green!float) ^^ 2;
		auto dBlue = (this.blue!float - rhs.blue!float) ^^ 2;

		return sqrt(dRed + dGreen + dBlue);
	}

	/++
		Arithmetic operations for colors
		Params:
			rhs  	= second color
	+/
	RGBColor opBinary(string op)(auto ref RGBColor rhs)
	{
		RGBColor result;

		static if (isGeneralOperation(op))
		{
			mixin("result = RGBColor.getColor(" ~
				"this.red!ubyte " ~ op ~ " rhs.red!ubyte," ~
				"this.green!ubyte " ~ op ~ " rhs.green!ubyte," ~
				"this.blue!ubyte " ~ op ~ "rhs.blue!ubyte" ~ ");"
				);
		}
		else
		{
			mixin("result = RGBColor.getColor(" ~
				"this.red!long " ~ op ~ " rhs.red!long," ~
				"this.green!long " ~ op ~ " rhs.green!long," ~
				"this.blue!long " ~ op ~ "rhs.green!long" ~ ");"
				);
		}

		return result;
	}

	/++ ditto +/
	void opOpAssign(string op)(auto ref RGBColor rhs)
	{
		mixin("setChannels(
			this.red!float " ~ op ~" rhs.red!float,
			this.green!float " ~ op ~" rhs.green!float,
			this.blue!float " ~ op ~" rhs.blue!float);");
	}

	/++
		Arithmetic operations between color and arithmetic types
		Params:
			rhs  	= variable
	+/
	RGBColor opBinary(string op, T)(auto ref T rhs)
		if (allArithmetic!T)
	{
		RGBColor result;

		static if (isGeneralOperation(op))
		{
			mixin("result = RGBColor.getColor(" ~
				"this.red!float " ~ op ~ " cast(float) rhs," ~
				"this.green!float " ~ op ~ " cast(float) rhs," ~
				"this.blue!float " ~ op ~ " cast(float) rhs," ~ ");"
				);
		}
		else
		{
			mixin("result = RGBColor.getColor(" ~
				"this.red!long " ~ op ~ " cast(long) rhs," ~
				"this.green!long " ~ op ~ " cast(long) rhs," ~
				"this.blue!long " ~ op ~ "cast(long) rhs," ~ ");"
				);
		}

		return result;
	}

	/++ ditto +/
	RGBColor opBinaryRight(string op, T)(auto ref T rhs)
		if (allArithmetic!T)
	{
		RGBColor result;

		static if (isGeneralOperation(op))
		{
			mixin("result = RGBColor.getColor(" ~
				"this.red!float " ~ op ~ " cast(float) rhs," ~
				"this.green!float " ~ op ~ " cast(float) rhs," ~
				"this.blue!float " ~ op ~ " cast(float) rhs," ~ ");"
				);
		}
		else
		{
			mixin("result = RGBColor.getColor(" ~
				"this.red!long " ~ op ~ " cast(long) rhs," ~
				"this.green!long " ~ op ~ " cast(long) rhs," ~
				"this.blue!long " ~ op ~ "cast(long) rhs," ~ ");"
				);
		}

		return result;
	}

	/++
		Gamma correction
		Params:
			coefficient 		= ...
			power 				= ...
		Returns:
			Corrected color
	+/
	RGBColor gamma(T, U)(T coefficient, U power)
		if (allArithmetic!(T, U))
	{
		auto red = cast(float) coefficient * ((this.red!float / 255.0) ^^ cast(float) power);
		auto green = cast(float) coefficient * ((this.green!float / 255.0) ^^ cast(float) power);
		auto blue = cast(float) coefficient * ((this.blue!float / 255.0) ^^ cast(float) power);

		return new RGBColor(red * 255.0, green * 255.0, blue * 255.0);
	}

	/++
		Logarithm of the color
		Params:
			base 	= base of logarithm
		Returns:
			New color - logarithm of the color
	+/
	RGBColor log(T)(T base = cast(T) 2)
		if (allArithmetic!(T, U))
	{
		assert(base != 0);
		auto red = (R == 0) ? 0 : log(this.red!float / 255.0) / log(cast(float) base);
		auto green = (G == 0) ? 0 : log(this.green!float / 255.0) / log(cast(float) base);
		auto blue = (B == 0) ? 0 : log(this.blue!float / 255.0) / log(cast(float) base);

		return new RGBColor(red * 255.0, green * 255.0, blue * 255.0);
	}

	/++
		Inversion
		Returns:
			New inverted color
	+/
	RGBColor invert()
	{
		return new RGBColor(255 - R, 255 - G, 255 - B);
	}

	/++ +/
	override string toString()
	{
		return format("RGBColor(%d, %d, %d)", R, G, B);
	}

	version(RgbCachingOn) {

		static int getCached() {
			return manager.getCached;
		}

	}
}

class RGBManager {
	RGBColor[][][] cache;
	int cached;
	bool fullInitialization;

	this(bool fullInitialization = false) {
		cache.length = 256;

		this.fullInitialization = fullInitialization;

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
		ubyte red = cast(ubyte) clamp(_red, 0, 255);
		ubyte green = cast(ubyte) clamp(_green, 0, 255);
		ubyte blue = cast(ubyte) clamp(_blue, 0, 255);

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
