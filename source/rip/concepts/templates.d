module rip.concepts.templates;

private
{
	import std.meta : allSatisfy;
	import std.range;
	import std.traits : isIntegral, isFloatingPoint, Unqual;

	import rip.concepts.color;
	import rip.concepts.surface;
}

/++
+  	Check all types for arithmetic types
+	Params:
+		T... 		=	types
+/
template allArithmetic(T...)
	if (T.length >= 1)
{
	template isNumberType(T)
	{
		enum bool isNumberType = isIntegral!(Unqual!T) || isFloatingPoint!(Unqual!T);

	}

	enum bool allArithmetic = allSatisfy!(isNumberType, T);
}

/++
+  	Check range for RGBColor elements
+	Params:
+		Range 		=	range
+/
template isPixelRange(Range)
{
	enum bool isPixelRange = is(ElementType!Range == RGBColor);
}

/++
+  	Creates getter function in compile-time
+	Params:
+		propertyVariableName 		=	name of variable
+		propertyName 				=	name of function
+/
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


/++
+  	Creates binary image operation in compile-time
+	Params:
+		operationSign 		=	...
+		operationName 		=	...
+/
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
