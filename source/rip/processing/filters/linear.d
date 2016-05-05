module rip.processing.filters.linear;

// Предок всех сверточных фильтров
abstract class LinearFilter
{
	protected
	{
		float[] flattenKernel;
		float apertureWidth, apertureHeight, apertureDivider, apertureOffset;
	}


	@property
	{
		float getWidth()
		{
			return apertureWidth;
		}


		float getHeight()
		{
			return apertureWidth;
		}


		float getDivider()
		{
			return apertureDivider;
		}


		float getOffset()
		{
			return apertureOffset;
		}


		float[] getKernel()
		{
			return flattenKernel;
		}
	}
}


// Преобразование двумерного массива в плоский одномерный
T[] flatten(T)(T[][] dataArray)
{
	T[] intermediateArray;

	foreach (i; 0 .. dataArray.length)
	{
		foreach (j; 0 .. dataArray[i].length)
		{
			intermediateArray ~= dataArray[i][j];
		}
	}

	return intermediateArray;
}
