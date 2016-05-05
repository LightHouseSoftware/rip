module rip.processing.filters.box;

private
{
	import rip.processing.filters.linear;

	float[] createBoxKernel(int width, int height)
	{
		float[] boxKernel;

		foreach (i; 0 .. width)
		{
			foreach(j; 0 .. height)
			{
				boxKernel ~= 1.0f;
			}
		}

		return boxKernel;
	}
}


class BoxFilter : LinearFilter
{
	this(int filterWidth, int filterHeight)
	{
		apertureWidth = filterWidth;
		apertureHeight = filterHeight;
		apertureDivider =  1.0f / (filterWidth * filterHeight);
		apertureOffset = 0.0f;
		flattenKernel = createBoxKernel(filterWidth, filterHeight);
	}
}
