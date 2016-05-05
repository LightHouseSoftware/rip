module rip.processing.filters.clarity;

private
{
	import rip.processing.filters.linear;
}


class ClarityFilter : LinearFilter
{
	this()
	{
		apertureWidth = 3;
		apertureHeight = 3;
		apertureDivider = 1.0f;
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[ -1.0f,  -1.0f,  -1.0f ],
				[ -1.0f,   9.0f,  -1.0f ],
				[ -1.0f,  -1.0f,  -1.0f ],
			]
			);
	}
}


class ClarityFilter2 : LinearFilter
{
	this()
	{
		apertureWidth = 3;
		apertureHeight = 3;
		apertureDivider = 1.0f;
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[ -.1f,  -.1f,  -.1f ],
				[ -.1f,  2.0f,  -.1f ],
				[ -.1f,  -.1f,  -.1f ],
			]
			);
	}
}
