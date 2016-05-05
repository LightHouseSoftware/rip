module rip.dsp.transforms.haar;

private
{
	import std.math;

	import rip.processing.filters.linear;

	static float SQ2 = cast(float) SQRT2;
}


class Haar2 : LinearFilter
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


class Haar4 : LinearFilter
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
				[ 1.0f,   1.0f,   -1.0f  -1.0f ],
				[ SQ2,   -SQ2,     0.0f,  0.0f ],
				[ 0.0f,   0.0f,    SQ2,   -SQ2 ],
			]
			);
	}
}


class Haar8 : LinearFilter
{
	this()
	{
		apertureWidth = 8;
		apertureHeight = 8;
		apertureDivider = 1.0f / sqrt(8.0f);
		apertureOffset = 0.0f;
		flattenKernel = flatten(
			[
				[ 1.0f,   1.0f,   1.0f,   1.0f,   1.0f,   1.0f,   1.0f,   1.0f ],
				[ 1.0f,   1.0f,   1.0f,   1.0f,  -1.0f,  -1.0f,  -1.0f,  -1.0f ],
				[ SQ2,    SQ2,   -SQ2,   -SQ2,    0.0f,   0.0f,   0.0f,   0.0f ],
				[ 0.0f,   0.0f,   0.0f,   0.0f,   SQ2,    SQ2,   -SQ2,   -SQ2  ],
				[ 2.0f,  -2.0f,   0.0f,   0.0f,   0.0f,   0.0f,   0.0f,   0.0f ],
				[ 0.0f,   0.0f,   2.0f,  -2.0f,   0.0f,   0.0f,   0.0f,   0.0f ],
				[ 0.0f,   0.0f,   0.0f,   0.0f,   2.0f,  -2.0f,   0.0f,   0.0f ],
				[ 0.0f,   0.0f ,  0.0f,   0.0f,   0.0f,   0.0f,   2.0f,  -2.0f ],
			]
			);
	}
}