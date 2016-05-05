module rip.processing.filters.kirsch;

private
{
	import rip.processing.filters.directions;
	import rip.processing.filters.linear;
}


class KirschFilter : LinearFilter
{
	this(CardinalDirection direction)
	{
		apertureWidth = 3;
		apertureHeight = 3;
		apertureDivider = 1.0f;
		apertureOffset = 0.0f;

		final switch (direction) with (CardinalDirection)
		{
			case NORTH:
				flattenKernel = flatten(
					[
						[ -3.0f,  -3.0f,  5.0f ],
						[ -3.0f,   0.0f,  5.0f ],
						[ -3.0f,   3.0f,  5.0f ],
					]
					);
				break;

			case NORTH_WEST:
				flattenKernel = flatten(
					[
						[ -3.0f,   5.0f,   5.0f ],
						[ -3.0f,   0.0f,   5.0f ],
						[ -3.0f,  -3.0f,  -3.0f ],
					]
					);
				break;

			case WEST:
				flattenKernel = flatten(
					[
						[  5.0f,   5.0f,   5.0f ],
						[ -3.0f,   0.0f,  -3.0f ],
						[ -3.0f,  -3.0f,  -3.0f ],
					]
					);
				break;

			case SOUTH_WEST:
				flattenKernel = flatten(
					[
						[  5.0f,   5.0f,  -3.0f ],
						[  5.0f,   0.0f,  -3.0f ],
						[ -3.0f,  -3.0f,  -3.0f ],
					]
					);
				break;

			case SOUTH:
				flattenKernel = flatten(
					[
						[  5.0f,  -3.0f,  -3.0f ],
						[  5.0f,   0.0f,  -3.0f ],
						[  5.0f,  -3.0f,  -3.0f ],
					]
					);
				break;

			case SOUTH_EAST:
				flattenKernel = flatten(
					[
						[ -3.0f,  -3.0f,  -3.0f ],
						[  5.0f,   0.0f,  -3.0f ],
						[  5.0f,   5.0f,  -3.0f ],
					]
					);
				break;

			case EAST:
				flattenKernel = flatten(
					[
						[ -3.0f,  -3.0f,  -3.0f ],
						[ -3.0f,   0.0f,  -3.0f ],
						[  5.0f,   5.0f,   5.0f ],
					]
					);
				break;

			case NORTH_EAST:
				flattenKernel = flatten(
					[
						[ -3.0f,  -3.0f,  -3.0f ],
						[ -3.0f,   0.0f,   5.0f ],
						[ -3.0f,   5.0f,   5.0f ],
					]
					);
				break;
		}
	}
}