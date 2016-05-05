module rip.concepts.surface;

private
{
	import std.algorithm;
	import std.conv;
	import std.range : array, iota, zip;
	import std.stdio : File;
	import std.string;

	import rip.concepts.color;
	import rip.concepts.ranges;
	import rip.concepts.templates;
}

// Универсальный тип для любых изображений
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
			auto W = cast(size_t) clamp(i, 0, width - 1);
			auto H = cast(size_t) clamp(j, 0, height - 1);
			auto S = width * height;

			return clamp(W + H * width, 0, S);
		}
	}

	// Параметризованный конструктор
	this(T, U)(T width, U height, RGBColor rgbColor = new RGBColor(0, 0, 0))
		if (allArithmetic!(T, U))
	{
		assert(width > 0);
		assert(height > 0);

		this.width = width;
		this.height = height;

		pixels = map!(a => rgbColor)(iota(width * height)).array;
	}

	// Длина изображения в пикселах
	mixin(addTypedGetter!("width", "getWidth"));

	// Ширина изображения в пикселах
	mixin(addTypedGetter!("height", "getHeight"));

	// Общее количество пикселей в изображении
	mixin(addTypedGetter!("(width * height)", "getArea"));

	@property
	{
		// Изменяемая копия изображения
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

		// Неизменяемая копия изображения
		immutable(Surface) idup()
		{
			return cast(immutable) this.dup;
		}
	}

	// Обращение к пикселу с помощью одного индекса
	RGBColor opIndex(T)(T i)
		if (allArithmetic!T)
	{
		return pixels[calculateRealIndex(i)];
	}

	// Обращение к пикселу с помощью двух индексов
	RGBColor opIndex(T, U)(T i, U j)
		if (allArithmetic!(T, U))
	{
		return pixels[calculateRealIndex(i, j)];
	}

	// Присвоение пикселу значения
	void opIndexAssign(T)(RGBColor rgbColor, T i)
		if (allArithmetic!T)
	{
		pixels[calculateRealIndex(i)] = rgbColor;
	}

	// То же самое, но в случае двумерных индексов
	void opIndexAssign(T, U)(RGBColor rgbColor, T i, U j)
		if (allArithmetic!(T, U))
	{
		pixels[calculateRealIndex(i, j)] = rgbColor;
	}

	auto getPixelsRange() {
		return createPixels(pixels);
	}

	auto getPixels() const {
		return pixels;
	}
};


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