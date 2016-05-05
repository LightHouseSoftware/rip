module rip.processing.filters.identity;

private
{
	import rip.processing.filters.linear;
}


class IdentityOperator : LinearFilter
{
	this()
	{
		apertureWidth = 3;
		apertureHeight = 3;
		apertureDivider = 1.0f;
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[ 0.0f,  0.0f,  0.0f ],
				[ 0.0f,  1.0f,  0.0f ],
				[ 0.0f,  0.0f,  0.0f ],
			]
			);
	}
}
