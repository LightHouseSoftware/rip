module rip.draw.ifs;

private
{
	import std.random;

	import rip.color.color;
	import rip.concepts.surface;
	import rip.concepts.templates;
	import rip.draw.primitives;
}

// Одно уравнение итерируемой системы функций
class Equation
{
	private
	{
		float a;
		float b;
		float c;
		float d;
		float e;
		float f;
	}

	// Коэффициент a
	mixin(addTypedGetter!("a", "getA"));

	// Коэффициент b
	mixin(addTypedGetter!("b", "getB"));

	// Коэффициент c
	mixin(addTypedGetter!("c", "getC"));

	// Коэффициент d
	mixin(addTypedGetter!("d", "getD"));

	// Коэффициент e
	mixin(addTypedGetter!("e", "getE"));

	// Коэффициент f
	mixin(addTypedGetter!("e", "getF"));

	// Установить коэффициент a
	void setA(T)(T a)
		if (allArithmetic!T)
	{
		this.a = cast(float) a;
	}

	// Установить коэффициент b
	void setB(T)(T b)
		if (allArithmetic!T)
	{
		this.b = cast(float) b;
	}

	// Установить коэффициент c
	void setC(T)(T c)
		if (allArithmetic!T)
	{
		this.c = cast(float) c;
	}

	// Установить коэффициент d
	void setD(T)(T d)
		if (allArithmetic!T)
	{
		this.d = cast(float) d;
	}

	// Установить коэффициент e
	void setE(T)(T e)
		if (allArithmetic!T)
	{
		this.e = cast(float) e;
	}

	// Установить коэффициент f
	void setF(T)(T f)
		if (allArithmetic!T)
	{
		this.f = cast(float) f;
	}
}

// Представление системы уравнений в виде ассоциативного массива 
// (в роли ключа - вероятность применения уравнения, в ролди значения - одно уравнение системы)
template EquationSystem(T)
	if (allArithmetic!T)
{
	alias EquationSystem = Equation[T];
}

// Класс для итерируемой системы функций 
class IFS(T)
{
	private
	{
		Surface surface;
		RGBColor color;
		EquationSystem!T equationSystem;
		ulong numberOfGeneration;

		float x;
		float y;
	}

	// Универсальный конструктор класса
	this(U, V, W)(Surface surface, RGBColor color, EquationSystem!T equationSystem, 
		U x, V y, W numberOfGeneration)
		if (allArithmetic!(T, U, V, W))
	{
		this.surface = surface;
		this.color = color;
		this.equationSystem = equationSystem;
		this.numberOfGeneration = cast(ulong) numberOfGeneration;

		this.x = cast(float) x;
		this.y = cast(float) y;
	}

	// Выполнить команды рисования итерируемой системы функций
	EquationSystem!T execute()
	{
		for (ulong i = 0; i < numberOfGeneration; i++)
		{
			drawPoint(surface, color, x, y);

			auto d = dice(equationSystem.keys);
			Equation eq = equationSystem[d];

			auto mul0 = eq.getA!float * x + eq.getB!float * y;
			auto mul1 = eq.getC!float * x + eq.getD!float * y;

			x = mul0 + eq.getE!float;
			y = mul1 + eq.getF!float;
		}
		
		return equationSystem;
	}
}
