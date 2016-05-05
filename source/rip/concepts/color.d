module rip.concepts.color;

private
{
	import std.algorithm : clamp;
	import std.math;
	import std.string;

	import rip.concepts.templates;
}

// Описание цвета пикселя
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

	// Параметризованный конструктор для облегчения работы с любым арифметическим типом
	this(T, U, V)(T red, U green, V blue)
		if (allArithmetic!(T, U, V))
	{
		setChannels(red, green, blue);
	}

	// Красная компонента цвета
	mixin(addTypedGetter!("R", "red"));

	// Зеленая компонента цвета
	mixin(addTypedGetter!("G", "green"));

	// Синяя компонента
	mixin(addTypedGetter!("B", "blue"));

	// Интенсивность цвета для человеческого глаза
	mixin(addTypedGetter!("0.3f * R + 0.59f * G + 0.11f * B", "luminance"));

	// Расстояние между двумя цветами в пространстве RGB
	T distance(T)(RGBColor rhs)
	{
		auto dRed = (this.red!float - rhs.red!float) ^^ 2;
		auto dGreen = (this.green!float - rhs.green!float) ^^ 2;
		auto dBlue = (this.blue!float - rhs.blue!float) ^^ 2;

		return sqrt(dRed + dGreen + dBlue);
	}

	// Арифметические операции для цветов
	RGBColor opBinary(string op)(auto ref RGBColor rhs)
	{
		RGBColor result;

		static if (isGeneralOperation(op))
		{
			mixin("result = new RGBColor(" ~
				"this.red!float " ~ op ~ " rhs.red!float," ~
				"this.green!float " ~ op ~ " rhs.green!float," ~
				"this.blue!float " ~ op ~ "rhs.blue!float," ~ ");"
				);
		}
		else
		{
			mixin("result = new RGBColor(" ~
				"this.red!long " ~ op ~ " rhs.red!long," ~
				"this.green!long " ~ op ~ " rhs.green!long," ~
				"this.blue!long " ~ op ~ "rhs.green!long," ~ ");"
				);
		}

		return result;
	}

	// Арифметические операции с левой стороныs
	void opOpAssign(string op)(auto ref RGBColor rhs)
	{
		mixin("setChannels(
			this.red!float " ~ op ~" rhs.red!float,
			this.green!float " ~ op ~" rhs.green!float,
			this.blue!float " ~ op ~" rhs.blue!float);");
	}

	// Арифметические операции между цветом и арифметическим скаляром
	RGBColor opBinary(string op, T)(auto ref T rhs)
		if (allArithmetic!T)
	{
		RGBColor result;
		
		static if (isGeneralOperation(op))
		{
			mixin("result = new RGBColor(" ~
				"this.red!float " ~ op ~ " cast(float) rhs," ~
				"this.green!float " ~ op ~ " cast(float) rhs," ~
				"this.blue!float " ~ op ~ " cast(float) rhs," ~ ");"
				);
		}
		else
		{
			mixin("result = new RGBColor(" ~
				"this.red!long " ~ op ~ " cast(long) rhs," ~
				"this.green!long " ~ op ~ " cast(long) rhs," ~
				"this.blue!long " ~ op ~ "cast(long) rhs," ~ ");"
				);
		}
		
		return result;
	}

	// Операции арифметики с правой стороны выражения
	RGBColor opBinaryRight(string op, T)(auto ref T rhs)
		if (allArithmetic!T)
	{
		RGBColor result;
		
		static if (isGeneralOperation(op))
		{
			mixin("result = new RGBColor(" ~
				"this.red!float " ~ op ~ " cast(float) rhs," ~
				"this.green!float " ~ op ~ " cast(float) rhs," ~
				"this.blue!float " ~ op ~ " cast(float) rhs," ~ ");"
				);
		}
		else
		{
			mixin("result = new RGBColor(" ~
				"this.red!long " ~ op ~ " cast(long) rhs," ~
				"this.green!long " ~ op ~ " cast(long) rhs," ~
				"this.blue!long " ~ op ~ "cast(long) rhs," ~ ");"
				);
		}
		
		return result;
	}

	// Гамма-коррекция
	RGBColor gamma(T, U)(T coefficient, U power)
		if (allArithmetic!(T, U))
	{
		auto red = cast(float) coefficient * ((this.red!float / 255.0) ^^ cast(float) power);
		auto green = cast(float) coefficient * ((this.green!float / 255.0) ^^ cast(float) power);
		auto blue = cast(float) coefficient * ((this.blue!float / 255.0) ^^ cast(float) power);

		return new RGBColor(red * 255.0, green * 255.0, blue * 255.0);
	}

	// Логарифмирование
	RGBColor log(T)(T base = cast(T) 2)
		if (allArithmetic!(T, U))
	{
		assert(base != 0);
		auto red = (R == 0) ? 0 : log(this.red!float / 255.0) / log(cast(float) base);
		auto green = (G == 0) ? 0 : log(this.green!float / 255.0) / log(cast(float) base);
		auto blue = (B == 0) ? 0 : log(this.blue!float / 255.0) / log(cast(float) base);
		
		return new RGBColor(red * 255.0, green * 255.0, blue * 255.0);
	}

	// Инвертирование цвета ( в качестве базиса - белый цвет)
	RGBColor invert()
	{
		return new RGBColor(255 - R, 255 - G, 255 - B);
	}

	// Строковое представление цвета
	string toString()
	{
		return format("RGBColor(%d, %d, %d)", R, G, B);
	}
}