module rip.processing.filters.laplace;

private
{
	import rip.processing.filters.linear;
}


class LaplaceOperator : LinearFilter
{
	this()
	{
		apertureWidth = 3;
		apertureHeight = 3;
		apertureDivider = 1.0f;
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[ 0.0f,   1.0f,  0.0f ],
				[ 1.0f,  -4.0f,  1.0f ],
				[ 0.0f,   1.0f,  0.0f ],
			]
			);
	}
}
