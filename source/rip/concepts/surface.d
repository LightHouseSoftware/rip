module rip.concepts.surface;

private
{
	import std.algorithm;
	import std.conv;
	import std.range : array, iota, zip;
	import std.stdio : File;
	import std.string;
	import std.array;

	import rip.color;
	import rip.concepts.ranges;
	import rip.concepts.templates;
}

/++
+  	Digital mplementation of images.
+/
class Surface  {
	private
	{
		RGBColor[] pixels;
		size_t width;
		size_t height;

		// Расчет одномерного индекса,с учетом возможного выхода за границы
		auto calculateRealIndex(T)(T i)
		{
			auto N = cast(size_t) i;
			auto S = width * height;

			return clamp(N, 0, S);
		}

		// Перевод двумерных индексов в одномерный индекс, с учетом возможного выхода за границы
		auto calculateRealIndex(T, U)(T i, U j)
			if (allArithmetic!(T, U))
		{
			auto W = cast(size_t) clamp(i, 0, cast(uint)(width - 1));
			auto H = cast(size_t) clamp(j, 0, cast(uint)(height - 1));
			auto S = width * height;

			return clamp(W + H * width, 0, S);
		}
	}

	/++
	+   Params:
	+     width =   	width of image
	+     height =      height of image
	+	  rgbColor =    main color
	+/
	this(T, U)(T width, U height)
		if (allArithmetic!(T, U))
	{
		assert(width > 0);
		assert(height > 0);

		this.width = width;
		this.height = height;

		pixels = uninitializedArray!(RGBColor[])(width * height);
	}

	void initialize(RGBColor color = RGBColor.getColor(0, 0, 0)) {
		pixels = map!(a => color)(iota(width * height)).array;
	}

	/++ Parametrized getter +/
	mixin(addTypedGetter!("width", "getWidth"));

	mixin(addTypedGetter!("height", "getHeight"));

	// Общее количество пикселей в изображении
	mixin(addTypedGetter!("(width * height)", "getArea"));

	@property
	{
		/++
		+   Returns:
		+     duplicate of surface
		+/
		Surface dup()
		{
			auto duplicateImage = new Surface(width, height);

			foreach (i; 0 .. width)
			{
				foreach (j; 0 .. height)
				{
					duplicateImage[i, j] = pixels[calculateRealIndex(i, j)];
				}
			}

			return duplicateImage;
		}

		/++
		+   Returns:
		+     immutable duplicate of surface
		+/
		immutable(Surface) idup()
		{
			return cast(immutable) this.dup;
		}
	}

	/++
	+	Params:
	+		i 	= index of pixel
	+   Returns:
	+     	pixel
	+	Example:
	+	-----------------
	+	Surface sur = new Surface[10, 10];
	+	RGBColor pixel = sur[45];
	+	-----------------
	+/
	RGBColor opIndex(T)(T i)
		if (allArithmetic!T)
	{
		return pixels[calculateRealIndex(i)];
	}

	/++
	+	Like opIndex. For two indexes
	+	Params:
	+		i 	= first index of pixel
	+		j 	= second index of pixel
	+   Returns:
	+     	Pixel
	+	Example:
	+	-----------------
	+	Surface sur = new Surface[10, 10];
	+	RGBColor pixel = sur[4, 6];
	+	----------------
	+/
	RGBColor opIndex(T, U)(T i, U j)
		if (allArithmetic!(T, U))
	{
		return pixels[calculateRealIndex(i, j)];
	}

	/++
	+	Params:
	+		rgbColor 	= new color of pixel
	+		i 	= first index of pixel
	+		j 	= second index of pixel
	+   Returns:
	+     	Pixel
	+	Example:
	+	-----------------
	+	Surface sur = new Surface[10, 10];
	+	sur[45] = new RGBColor(0, 45, 65);
	+	-----------------
	+/
	void opIndexAssign(T)(RGBColor rgbColor, T i)
		if (allArithmetic!T)
	{
		pixels[calculateRealIndex(i)] = rgbColor;
	}

	/++
	+	Like opIndexAssign. For two indexes.
	+	Params:
	+		rgbColor 	= new color of pixel
	+		i 	= first index of pixel
	+		j 	= second index of pixel
	+   Returns:
	+     	Pixel
	+	Example:
	+	-----------------
	+	Surface sur = new Surface[10, 10];
	+	sur[4, 5] = new RGBColor(0, 45, 65);
	+	-----------------
	+/
	void opIndexAssign(T, U)(RGBColor rgbColor, T i, U j)
		if (allArithmetic!(T, U))
	{
		pixels[calculateRealIndex(i, j)] = rgbColor;
	}


	/++
	+ 	Create pixel's range and return it;
	+   Returns:
	+     	PixelsRange
	+/
	auto getPixelsRange() {
		return createPixels(pixels);
	}

	/++
	+   Returns:
	+     	Array of pixels
	+/
	auto getPixels() const {
		return pixels;
	}
}


// Сложение двух картинок
mixin(addBinaryImageOperation!("+","add"));

// Вычитание двух картинок
mixin(addBinaryImageOperation!("-","subtract"));

// Умножение двух картинок
mixin(addBinaryImageOperation!("*","multiply"));

// Деление двух картинок
mixin(addBinaryImageOperation!("/","divide"));

// Остаток от деление одной картинки на другую
mixin(addBinaryImageOperation!("%","mod"));

// Возведение в степень
mixin(addBinaryImageOperation!("^^","power"));

// Логическое "И" двух картинок
mixin(addBinaryImageOperation!("&","and"));

// Логическое "ИЛИ" двух картинок
mixin(addBinaryImageOperation!("|","or"));

// Исключающее "ИЛИ" двух картинок
mixin(addBinaryImageOperation!("^","xor"));
