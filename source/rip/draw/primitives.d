module rip.draw.primitives;

private
{
	import std.algorithm;
	import std.math;

	import rip.color;
	import rip.concepts.surface;
	import rip.concepts.templates; 
}

// Рисование точки
auto drawPoint(T, S)(Surface surface, RGBColor rgbColor, T x, S y)
	if (allArithmetic!(T, S))
{
	surface[x, y] = rgbColor;
}

// Рисование линии с помощью цифрового дифференциального анализатора
auto drawDDALine(T, U, V, W)(Surface surface, RGBColor rgbColor,T x1, U y1, V x2, W y2)
	if (allArithmetic!(T, U, V, W))
{
	auto deltaX = abs(x1 - x2);
	auto deltaY = abs(y1 - y2);
	auto L = max(deltaX, deltaY);

	if (L == 0)
	{
		surface[x1, y1] = rgbColor;
	}

	auto dx = (x2 - x1) / L;
	auto dy = (y2 - y1) / L;
	float x = x1;
	float y = y1;

	L++;
	while(L--)
	{
		x += dx;
		y += dy;
		surface[x1, y1] = rgbColor;
	}
}

// Рисование линии методом Брезенхема
auto drawBresenhamLine(T, U, V, W)(Surface surface, RGBColor color, T x1, U y1, V x2, W y2)
	if (allArithmetic!(T, U, V, W))
{
	float a = cast(float) x1;
	float b = cast(float) y1;
	float c = cast(float) x2;
	float d = cast(float) y2;

	float dx = (x2 - x1 >= 0 ? 1 : -1);
	float dy = (y2 - y1 >= 0 ? 1 : -1);
	
	float lengthX = abs(x2 - x1);
	float lengthY= abs(y2 - y1);
	float length = max(lengthX, lengthY);
	
	if (length == 0)
	{
		surface[x1, y1] = color;
	}
	
	if (lengthY <= lengthX)
	{
		float x = x1;
		float y = y1;
		
		length++;
		while (length--)
		{
			surface[x, y] = color;
			x += dx;
			y += (dy * lengthY) / lengthX;
		}
	}
	else
	{
		float x = x1;
		float y = y1;
		
		length++;
		while(length--)
		{
			surface[x, y] = color;
			x += (dx * lengthX) / lengthY;
			y += dy;
		}
	}
}

// Рисование окружности
auto drawCircle(T, U, V)(Surface surface, RGBColor color, T x, U y, V r)
	if (allArithmetic!(T, U, V))
{	
	assert (r >= 0);

	auto a = cast(float) x;
	auto b = cast(float) y;
	auto c = cast(float) r;

	for (float i = 0.0; i < 360.0; i += 0.01)
	{
		auto X = cast(int) (a + c * cos(i * PI / 180.0));
		auto Y = cast(int) (b + c * sin(i * PI / 180.0));
		surface[X, Y] = color;
	}
}

// Рисование конических сечений
auto drawConicSection(T, U, V, W)(Surface surface, RGBColor color, T x, U y, V l, W e)
	if (allArithmetic!(T, U, V, W))
{
	auto a = cast(float) x;
	auto b = cast(float) y;
	auto c = cast(float) l;
	auto d = cast(float) e;

	for (float i = 0.0; i < 360.0; i += 0.01)
	{
		auto r = c / (1.0 - d * cos(i * PI / 180.0));
		auto X = cast(int) (a + c * cos(i * PI / 180.0));
		auto Y = cast(int) (b + c * sin(i * PI / 180.0));
		surface[X, Y] = color;
	}
}

// Рисование треугольника
auto drawTriangle(P, Q, R, S, T, U)(Surface surface, RGBColor color, P x1, Q y1, R x2, S y2, T x3, U y3)
	if (allArithmetic!(P, Q, R, S, T, U))
{
	auto a = cast(int) x1;
	auto b = cast(int) y1;
	auto c = cast(int) x2;
	auto d = cast(int) y2;
	auto e = cast(int) x3;
	auto f = cast(int) y3;

	surface.drawPoint(color, a, b);
	surface.drawPoint(color, c, d);
	surface.drawPoint(color, e, f);

	surface.drawDDALine(color, a, b, c, d);
	surface.drawDDALine(color, c, d, e, f);
	surface.drawDDALine(color, e, f, a, b);
}

// Рисование прямоугольника
auto drawRectangle(T, U, V, W)(Surface surface, RGBColor color, T x, U y, V w, W h)
	if (allArithmetic!(T, U, V, W))
{
	assert(w >= 0);
	assert(h >= 0);

	auto X = cast(int) x;
	auto Y = cast(int) y;
	auto WW = cast(int) w;
	auto HH = cast(int) h;

	for (int a = 0; a < HH; a++)
	{
		surface[X, Y + a] = color;
	}
	
	for (uint b = 0; b < WW; b++)
	{
		sutface[X + b, Y + HH] = color;
	}

	for (uint c = 0; c < HH; c++)
	{
		surface[X + WW, Y + c] = color;
	}

	for (uint d = 0; d < WW; d++)
	{
		surface[X + d, Y] = color;
	}
}

// Окружность с заливкой
auto drawFilledCircle(T, U, V)(Surface surface, RGBColor color, T x, U y, V r)
	if (allArithmetic!(T, U, V))
{
	auto a = cast(float) x;
	auto b = cast(float) y;
	auto c = cast(float) r;
	
	for (float i = 0.0; i < 360.0; i += 0.01)
	{
		for (float j = 0; j < c; j++)
		{
			auto X = cast(int) (a + j * cos(i * PI / 180.0));
			auto Y = cast(int) (b + j * sin(i * PI / 180.0));
			surface[X, Y] = color;
		}
	}
}

// Треугольник с заливкой
auto drawFilledTriangle(P, Q, R, S, T, U)(Surface surface, RGBColor color, P x1, Q y1, R x2, S y2, T x3, U y3)
	if (allArithmetic!(P, Q, R, S, T, U))
{
	// рисуем треугольник обычный
	auto a = cast(float) x1;
	auto b = cast(float) y1;
	auto c = cast(float) x2;
	auto d = cast(float) y2;
	auto e = cast(float) x3;
	auto f = cast(float) y3;
	
	surface.drawPoint(color, a, b);
	surface.drawPoint(color, c, d);
	surface.drawPoint(color, e, f);
	
	surface.drawDDALine(color, a, b, c, d);
	surface.drawDDALine(color, c, d, e, f);
	surface.drawDDALine(color, e, f, a, b);

	// вычисление знаменателя для барицентрических координат
	auto calculateDenominator(float X1, float Y1, float X2, float Y2, float X3, float Y3)
	{
		return ((Y2 - Y3) * (X1 - X3)) + ((X3 - X2) * (Y1 - Y3));
	}

	// вычисляем первую барицентрическую координату
	auto calculateL1(float x, float y)
	{
		auto numerator = ((b - f) * (x - e)) + ((e - c) * (y - f));
		auto denominator = calculateDenominator(a, b, c, d, e, f);
		return numerator / denominator;
	}

	// вычисляем вторую барицентрическую координату
	auto calculateL2(float x, float y)
	{
		auto numerator = ((f - a) * (x - e)) + ((a - e) * (y - f));
		auto denominator = calculateDenominator(a, b, c, d, e, f);
		return numerator / denominator;
	}

	// вычисляем третью барицентрическую координату
	auto calculateL3(float L1, float L2)
	{
		return 1.0 - L1 - L2;
	}

	// подготовка данных для цикла отрисовки
	auto xmin = min(a, c, e);
	auto xmax = max(a, c, e);
	auto ymin = min(b, d, f);
	auto ymax = max(b, d, f);

	// Находиться ли величина в интервале [0..1]
	bool isBaricentric(float value)
	{
		return ((value >= 0) && (value <= 1.0));
	}

	// Находиться ли точка внутри плоскости, ограниченной линиями треугольника
	bool isInsideOfTriangle(float x, float y)
	{
		auto L1 = calculateL1(x, y);
		auto L2 = calculateL2(x, y);
		auto L3 = calculateL1(L1, L2);
		return ((isBaricentric(L1) && isBaricentric(L2) && isBaricentric(L3)));
	}

	// заливка треугольника
	for (float x = xmin; x < xmax; x += 0.1)
	{
		for (float y = ymin; y < ymax; y += 0.1)
		{
			if (isInsideOfTriangle(x, y))
			{
				surface[cast(int) x, cast(int) y] = color;
			}
		}
	}
}

// Прямоугольник с заливкой
auto drawFilledRectangle(T, U, V, W)(Surface surface, RGBColor color, T x, U y, W w, H h)
	if (allArithmetic!(T, U, V, W))
{
	assert(w >= 0);
	assert(h >= 0);
	
	auto X = cast(int) x;
	auto Y = cast(int) y;
	auto WW = cast(int) w;
	auto HH = cast(int) h;

	for (int i = 0; i < WW; i++)
	{
		for (int j = 0; j < HH; j++)
		{
			surface[X + i, Y + j] = color;
		}
	}
}
