module rip.color.rgb;

private
{
	import std.algorithm : clamp;
	import std.math;
	import std.string;

	import rip.concepts.templates;
	import rip.rt.rgbCaching;
	import rip.color.color;
}

//Kill me
public import rip.color.rgbManager;

//delete 
version(RgbCachingOn) {
	private alias manager = rgbManager;
}

/++
	Digital implementation of RGB color format.
+/
class RGB : Color!(ubyte, 3)
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

		@property void R(T)(T value) {
			super[0] = value;
		}

		@property void G(T)(T value) {
			super[1] = value;
		}

		@property void B(T)(T value) {
			super[2] = value;
		}

		@property auto R(T = ubyte)() const {
			return super.getTypedByIndex!T(0);
		}

		@property auto G(T = ubyte)() const {
			return super.getTypedByIndex!T(1);
		}

		@property auto B(T = ubyte)() const {
			return super.getTypedByIndex!T(2);
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
		super(red, green, blue);
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

alias RGBColor = RGB;