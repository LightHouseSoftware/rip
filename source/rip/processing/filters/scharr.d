module rip.processing.filters.scharr;

private
{
	import rip.processing.filters.directions;
	import rip.processing.filters.linear;
}


class ScharrOperator : LinearFilter
{
	this(CartesianDirection direction)
	{
		apertureWidth = 3;
		apertureHeight = 3;
		apertureDivider = 1.0f;
		apertureOffset = 0.0f;

		final switch (direction) with (CartesianDirection)
		{
			case X:
				flattenKernel = flatten(
					[
						[ 3.0f,  0.0f,   -3.0f ],
						[ 10.0f,  0.0f,  -10.0f ],
						[ 3.0f,  0.0f,   -3.0f ],
					]
					);
				break;
			case Y:
				flattenKernel = flatten(
					[
						[  3.0f,   10.0f,   3.0f ],
						[  0.0f,   0.0f,    0.0f ],
						[ -3.0f,  -10.0f,  -3.0f ],
					]
					);
				break;
			case XY:
				flattenKernel = flatten(
					[
						[  9.0f,   0.0f,  -9.0f ],
						[  0.0f,   0.0f,    0.0f ],
						[ -9.0f,  -0.0f,   9.0f ],
					]
					);
				break;
		}
	}
}
