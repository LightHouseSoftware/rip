module rip.processing.filters.area;

private
{
	import rip.processing.filters.linear;
}


class Area4Filter : LinearFilter
{
	this()
	{
		apertureWidth = 3;
		apertureHeight = 3;
		apertureDivider = 1.0f;
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[ 0.0f,  1.0f,  0.0f ],
				[ 1.0f,  1.0f,  1.0f ],
				[ 0.0f,  1.0f,  0.0f ],
			]
			);
	}
}


class Area8Filter: LinearFilter
{
	this()
	{
		apertureWidth = 5;
		apertureHeight = 5;
		apertureDivider = 1.0f;
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[0.0f, 0.0f, 1.0f, 0.0f, 0.0f ],
				[0.0f, 0.0f, 1.0f, 0.0f, 0.0f ],
				[1.0f, 1.0f, 1.0f, 1.0f, 1.0f ],
				[0.0f, 0.0f, 1.0f, 0.0f, 0.0f ],
				[0.0f, 0.0f, 1.0f, 0.0f, 0.0f ],
			]
			);
	}
}
