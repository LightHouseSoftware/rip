module rip.dsp.transforms.slant;

private
{
	import std.math;
	
	import rip.processing.filters.linear;
	
	static float SQ2 = cast(float) SQRT2;
	static float SQ5 = cast(float) (1.0f / sqrt(5.0));
	static float TR =  cast(float) (3.0f / sqrt(5.0));
}


class Slant2 : LinearFilter
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


class Slant4: LinearFilter
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
				[ TR,     SQ5,    -SQ5,  -TR   ],
				[ 1.0f,  -1.0f,   -1.0f,  1.0f ],
				[ SQ5,   -TR,      SQ5,   TR   ],
			]
			);
	}
}
