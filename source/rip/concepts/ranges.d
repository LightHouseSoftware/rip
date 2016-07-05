module rip.concepts.ranges;

private
{
	import std.algorithm;
	import std.stdio;
	import std.range;

	import rip.concepts.color;
	import rip.concepts.surface;
	import rip.concepts.templates;
}

/++
+  	Creates surface from input range of pixels
+	Params:
+		r  			= input range
+		width		= width of new surface
+		height		= height of new surface
+	Returns:
		Created surface
+/
Surface toSurface(Range)(Range r, size_t width, size_t height)
	if (isPixelRange!Range)
{
	Surface surface = new Surface(width, height);

	auto s = width * height;

	foreach(i; 0..s) {
		surface[i] = r.front;
		r.popFront();
	}

	return surface;
}

/++
+  	Creates biderectional range from other range of pixels
+	Params:
+		r  			= input range
+	Returns:
		Biderectional range
+/
auto createPixels(Range)(Range r)
{
	struct PixelRange
	{
		private RGBColor[] pixels;

		this(Range)(Range r)
			if (is(ElementType!Range == RGBColor))
		{
			pixels = r.array;
		}

		@property
		{
			RGBColor back()
			{
				return pixels.back;
			}

			bool empty()
			{
				return pixels.empty;
			}

			RGBColor front()
			{
				return pixels.front;
			}
		}

		void popFront()
		{
			pixels.popFront();
		}

		void popBack()
		{
			pixels.popBack();
		}

		PixelRange save()
		{
			return this;
		}
	}

	return PixelRange(r);
}

/++
+  	Lazy and fast version of createFences.
+	P.S. FOR DETAILS SEE SOURCE
+	Params:
+		surface 		= input surface
+		width			= fence width
+		height			= fence height
+	Returns:
+		Biderectional range of pixels range[width * height]
+/
auto createFencesNew(T, U)(Surface surface, T width, U height) {

		/++
		+  	Struct for calculation one fence
		+/
		struct Fence {
			uint surfacePixelIndex;
			uint processedIndex = 0;

			uint x, y;
			uint halfFenceWidth, halfFenceHeight;

			/+
			+	Calculate and return pixel
			+	Params:
			+		index 		= index of pixel
			+	Returns:
					RGBColor
			+/

			auto opIndex(uint index) {
				uint h = cast(int)(index % width);
				uint w = cast(int)(index / width);

				auto indexW = x + (halfFenceWidth - w);
				auto indexH = y + (halfFenceHeight - h);

				if ((indexW < 0) || (indexH >= surface.getArea!int)) {
					return new RGBColor(255, 255, 255);
				}
				else {
					return surface[indexW, indexH];
				}
			}

			/+
			+	Params:
			+		surfacePixelIndex 		= index of main pixel for fence
			+		halfFenceWidth 			= ...
			+		halfFenceHeight 		= ...
			+	Returns:
			+		RGBColor
			+/
			this(	uint surfacePixelIndex,
					uint halfFenceWidth, uint halfFenceHeight) {

				this.surfacePixelIndex = surfacePixelIndex;
				this.halfFenceWidth = halfFenceWidth;
				this.halfFenceHeight = halfFenceHeight;

				x = surfacePixelIndex % surface.getWidth!uint;
				y = surfacePixelIndex / surface.getWidth!uint;
			}


			auto front() {
				return this.opIndex(processedIndex);
			}

			void popFront() {
				processedIndex++;
			}

			bool empty() {
				return processedIndex == width * height;
			}
		}

		struct FenceRange {
			int processedIndex = 0;

			Surface _surface;
			uint halfFenceWidth, halfFenceHeight;

			this(Surface _surface) {
				this._surface = _surface;

				halfFenceWidth = cast(uint) width / 2;
				halfFenceHeight = cast(uint) height / 2;
			}

			Fence front() {
				return Fence(	processedIndex,
								halfFenceWidth, halfFenceHeight);
			}

			void popFront() {
				processedIndex++;
			}

			bool empty() {
				return processedIndex == surface.getArea!int;
			}
		}

		return FenceRange(surface);
}

/++
+  	Returns fences range from surface
+	P.S. FOR DETAILS SEE SOURCE
+	Params:
+		surface 		= input surface
+		width			= fence width
+		height			= fence height
+	Returns:
		Biderectional range of pixels range[width * height]
+/
auto createFences(T, U)(Surface surface, T width, U height)
{
	alias Range = typeof(createPixels([RGBColor.init]));

	struct FenceRange(T, U, Range)
		if (allArithmetic!(T, U))
	{
		private Range[] pixelsRange;

		this(T, U)(Surface surface, T width, U height)
			if (allArithmetic!(T, U))
		{
			int halfFenceWidth = cast(int) width / 2;
			int halfFenceHeight = cast(int) height / 2;

			for (int i = 0; i < surface.getHeight!int; i++)
			{
				for (int j = 0; j < surface.getWidth!int; j++)
				{
					ElementType!Range[] fenceAccumulator;

					for (int w = 0; w < cast(int) width; w++)
					{
						for (int h = 0; h < cast(int) height; h++)
						{
							auto indexW = j + (halfFenceWidth - w);
							auto indexH = i + (halfFenceHeight - h);
							if ((indexW < 0) || (indexH >= surface.getArea!int))
							{
								fenceAccumulator ~= new RGBColor(0, 0, 0);
							}
							else
							{
								fenceAccumulator ~= surface[indexW, indexH];
							}
						}
					}

					pixelsRange ~= createPixels(fenceAccumulator);
				}
			}
		}

		@property
		{
			Range back()
			{
				return pixelsRange.back;
			}

			bool empty()
			{
				return (pixelsRange.length == 0);
			}

			Range front()
			{
				return pixelsRange.front;
			}
		}

		void popFront()
		{
			pixelsRange.popFront;
		}

		void popBack()
		{
			pixelsRange.popBack;
		}
	}

	return FenceRange!(T, U, Range)(surface, width, height);
}
