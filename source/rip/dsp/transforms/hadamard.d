module rip.dsp.transforms.hadamard;

private
{
	import std.math;
	
	import rip.processing.filters.linear;

	static float SQ2 = cast(float) SQRT2;
}


class Hadamard2 : LinearFilter
{
	this()
	{
		apertureWidth = 2;
		apertureHeight = 2;
		apertureDivider =  1.0 / SQ2;
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[ 1.0f,   1.0f ],
				[ 1.0f,  -1.0f ],
			]
			);
	}
}


class Hadamard4: LinearFilter
{
	this()
	{
		apertureWidth = 4;
		apertureHeight = 4;
		apertureDivider =  0.5f;
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[ 1.0f,   1.0f,    1.0f,  1.0f ],
				[ 1.0f,  -1.0f,    1.0f  -1.0f ],
				[ 1.0f,   1.0f,   -1.0f, -1.0f ],
				[ 1.0f,  -1.0f,   -1.0f,  1.0f ],
			]
			);
	}
}


class Hadamard8 : LinearFilter
{
	this()
	{
		apertureWidth = 8;
		apertureHeight = 8;
		apertureDivider = 1.0f / SQ2;
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[ 1.0f,   1.0f,   1.0f,   1.0f,   1.0f,   1.0f,   1.0f,   1.0f ],
				[ 1.0f,  -1.0f,   1.0f,  -1.0f,   1.0f,  -1.0f,   1.0f,  -1.0f ],
				[ 1.0f,   1.0f,  -1.0f,  -1.0f,   1.0f,   1.0f,  -1.0f,  -1.0f ],
				[ 1.0f,  -1.0f,  -1.0f,   1.0f,   1.0f,  -1.0f,  -1.0f,   1.0f ],
				[ 1.0f,   1.0f,   1.0f,   1.0f,  -1.0f,  -1.0f,  -1.0f,  -1.0f ],
				[ 1.0f,  -1.0f,   1.0f,  -1.0f,  -1.0f,   1.0f,  -1.0f,   1.0f ],
				[ 1.0f,   1.0f,  -1.0f,  -1.0f,  -1.0f,  -1.0f,   1.0f,   1.0f ],
				[ 1.0f,  -1.0f , -1.0f,   1.0f,  -1.0f,   1.0f,   1.0f,  -1.0f ],
			]
			);
	}
}