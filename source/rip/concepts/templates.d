module rip.concepts.templates;

private 
{
	import std.meta : allSatisfy;
	import std.range : zip;
	import std.traits : isIntegral, isFloatingPoint, Unqual;

	import rip.concepts.color;
	import rip.concepts.surface;
}

template allArithmetic(T...)
	if (T.length >= 1)
{
	template isNumberType(T)
	{
		enum bool isNumberType = isIntegral!(Unqual!T) || isFloatingPoint!(Unqual!T);

	}

	enum bool allArithmetic = allSatisfy!(isNumberType, T);
}


template addTypedGetter(string propertyVariableName, string propertyName)
{
	import std.string : format;

	const char[] addTypedGetter = format(
		`
		@property
		{
			T %2$s(T)() const
			{
				alias typeof(return) returnType;
				return cast(returnType) %1$s;
			}
		}`,
		propertyVariableName,
		propertyName
		);
}


// бинарные операции на целом изображении при условии, что аналогичные операции
// определены для RGBColor
template addBinaryImageOperation(string operationSign, string operationName)
{
	import std.string : format;
	
	const char[] addBinaryImageOperation = format(
		`auto %2$s(Surface lhs, Surface rhs)
		{
			assert(lhs.getWidth!ulong == rhs.getWidth!ulong);
			assert(lhs.getHeight!ulong == rhs.getHeight!ulong);

			RGBColor[] pixels;

			auto intermediateResult = zip(
				lhs.getPixelsRange,
				rhs.getPixelsRange
			);

			foreach (pixel; intermediateResult)
			{
				pixels ~= pixel[0] %1$s pixel[1];
			}

			return pixels.toSurface(
				lhs.getWidth!ulong, 
				lhs.getHeight!ulong
			);
		}`,
		operationSign,
		operationName
		);
}