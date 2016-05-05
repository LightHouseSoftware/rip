module rip.draw.primitives;

private
{
	import std.algorithm;
	import std.math;

	import rip.concepts.color;
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
void drawBresenhamLine(T, U, V, W)(Surface surface, RGBColor color, T x1, U y1, V x2, W y2)
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
void drawCircle(T, U, V)(Surface surface, RGBColor color, T x, U y, V r)
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
void drawConicSection(T, U, V, W)(Surface surface, RGBColor color, T x, U y, V l, W e)
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


// Рисование прямоугольника
void drawRectangle(T, U, V, W)(Surface surface, RGBColor color, T x, U y, V w, W h)
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
void drawFilledCircle(T, U, V)(Surface surface, RGBColor color, T x, U y, V r)
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

// Прямоугольник с заливкой
void drawFilledRectangle(T, U, V, W)(Surface surface, RGBColor color, T x, U y, W w, H h)
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