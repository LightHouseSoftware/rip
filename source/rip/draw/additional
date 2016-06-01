module rip.draw.additional;

private
{
	import std.algorithm;
	import std.math;
	
	import rip.concepts.color;
	import rip.concepts.mathematics;
	import rip.concepts.surface;
	import rip.concepts.templates;
	
	import rip.draw.primitives;
}

// Рисование точки в полярных координатах (угол в радианах !)
auto drawPolarPoint(T, S)(Surface surface, RGBColor rgbColor, T r, S phi)
	if (allArithmetic!(T, S))
{
	auto R = cast(float) r;
	auto P = cast(float) phi;
	
	auto X = R * cos(P);
	auto Y = R * sin(P);
	
	surface.drawPoint(color, X, Y);
}

auto drawPolarPoint(T, S, U, V)(Surface surface, RGBColor rgbColor, T r, S phi, U x, V y)
	if (allArithmetic!(T, S, U, V))
{
	auto R = cast(float) r;
	auto P = cast(float) phi;
	
	auto X = R * cos(P);
	auto Y = R * sin(P);
	
	surface.drawPoint(color, X + cast(float) x, Y + cast(float) y);
}

// Рисование линии в полярных координатах (угол в радианах !)
auto drawRadiusOf(T, S, U, V)(Surface surface, RGBColor rgbColor, T r, S phi, U x, V y)
	if (allArithmetic!(T, S, U, V))
{
	auto R = cast(float) r;
	auto P = cast(float) phi;
	
	auto X = R * cos(P);
	auto Y = R * sin(P);
	
	surface.drawDDALine(color, X, Y, X + cast(float) x, Y + cast(float) y);
}

auto drawRadiusOf(T, S, U)(Surface surface, RGBColor rgbColor, T r, S phi, U x)
	if (allArithmetic!(T, S, U, V))
{
	auto R = cast(float) r;
	auto P = cast(float) phi;
	auto radius = cast(float) x;
	
	auto X = R * cos(P);
	auto Y = R * sin(P);
	
	surface.drawDDALine(color, X, Y, X + radius, Y + radius);
}

auto drawPolarLine(T, S, U, V)(Surface surface, RGBColor rgbColor, T r1, S phi1, U r2, V phi2)
	if (allArithmetic!(T, S, U, V))
{
	auto R1 = cast(float) r1;
	auto P1 = cast(float) phi2;
	auto R2 = cast(float) r1;
	auto P2 = cast(float) phi2;
	
	auto X1 = R1 * cos(P1);
	auto Y1 = R1 * sin(P1);
	auto X2 = R2 * cos(P2);
	auto Y2 = R2 * sin(P2);
	
	surface.drawDDALine(color, X1, Y1, X2, Y2);
}

auto drawPolarLine(T, S, U, V, W, Y)(Surface surface, RGBColor rgbColor, T r1, S phi1, U r2, V phi2, W x, Y y)
	if (allArithmetic!(T, S, U, V, W, Y))
{
	auto R1 = cast(float) r1;
	auto P1 = cast(float) phi2;
	auto R2 = cast(float) r1;
	auto P2 = cast(float) phi2;
	
	auto X1 = R1 * cos(P1);
	auto Y1 = R1 * sin(P1);
	auto X2 = R2 * cos(P2);
	auto Y2 = R2 * sin(P2);
	
	surface.drawDDALine(color, X1 + cast(float) x, Y2 + cast(float) y, X2 + cast(float) x, Y2 + cast(float) y);
}

// Полярная роза
auto drawPolarRose(T, U, V, W, Y)(Surface surface, RGBColor rgbColor, U x, V y, V m, W n, Y length)
	if (allArithmetic!(T, U, V, W, Y))
{
	auto M = cast(float) m;
	auto N = cast(float) n;
	auto L = cast(float) L;
	
	for (float i = 0.0; i < 360.0; i += 0.01)
	{
		auto R = M * sin(N * degreesInRadians(i));
		surface.drawPolarPoint(color, L * i, L * R, x, y);
	}
}

// Закрашенная полярная роза
auto drawFilledPolarRose(T, U, V, W, Y)(Surface surface, RGBColor rgbColor, U x, V y, V m, W n, Y length)
	if (allArithmetic!(T, U, V, W, Y))
{
	auto M = cast(float) m;
	auto N = cast(float) n;
	auto L = cast(float) L;
	
	for (float i = 0.0; i < 360.0; i += 0.01)
	{
		auto R = M * sin(N * degreesInRadians(i));
		surface.drawRadiusOf(color, L * i, L * R, x, y);
	}
}

// Лево-закрученная спираль Архимеда
auto drawLeftSpiralOfArchimedes(T, U, V, W)(Surface surface, RGBColor rgbColor, U x, V y, V m, W n)
	if (allArithmetic!(T, U, V, W))
{
	auto M = cast(float) m;
	auto N = cast(float) n;
	auto L = cast(float) L;
	
	for (float i = -360.0 * N; i < 0.0; i += 0.01)
	{
		auto R = M + N * i;
		surface.drawPolarPoint(color, i, R, x, y);
	}
}

// Право-закрученная спираль Архимеда
auto drawLeftSpiralOfArchimedes(T, U, V, W)(Surface surface, RGBColor rgbColor, U x, V y, V m, W n)
	if (allArithmetic!(T, U, V, W))
{
	auto M = cast(float) m;
	auto N = cast(float) n;
	auto L = cast(float) L;
	
	for (float i = 0.0; i < 360.0 * N; i += 0.01)
	{
		auto R = M + N * i;
		surface.drawPolarPoint(color, i, R, x, y);
	}
}
