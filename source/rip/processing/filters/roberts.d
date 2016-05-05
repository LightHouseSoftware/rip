module rip.processing.filters.roberts;

private
{
	import rip.processing.filters.directions;
	import rip.processing.filters.linear;
}


class RobertsOperator : LinearFilter
{
	this(CartesianDirection direction)
	{
		apertureWidth = 2;
		apertureHeight = 2;
		apertureDivider = 1.0f;
		apertureOffset = 0.0f;
		
		final switch (direction) with (CartesianDirection)
		{
			case X:
				flattenKernel = flatten(
					[
						[ -1.0f,  0.0f ],
						[  0.0f,  1.0f ],
					]
					);
				break;
			case Y:
				flattenKernel = flatten(
					[
						[  0.0f, -1.0f ],
						[  1.0f,  0.0f ],
					]
					);
				break;
			case XY:
				flattenKernel = flatten(
					[
						[  0.0f,  0.0f ],
						[  0.0f,  0.0f ],
					]
					);
				break;
		}
	}
}

