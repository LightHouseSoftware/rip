module rip.processing.filters.gaussian;

private
{
	import rip.processing.filters.linear;
}


class GaussianBlur : LinearFilter
{
	this()
	{
		apertureWidth = 3;
		apertureHeight = 3;
		apertureDivider = 1.0f / 16.0f;
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[ 1.0f,   2.0f,  1.0f ],
				[ 2.0f,   4.0f,  2.0f ],
				[ 1.0f,   2.0f,  1.0f ],
			]
			);
	}
}
