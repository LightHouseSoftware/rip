module rip.parallelism.pmap;

import std.algorithm;
import std.parallelism;
import std.range;

template pmap(fun...) {
	auto pmap(Range) (Range inputRange) {

		alias RangeElementType = ElementType!Range;

		auto size = inputRange.length;
		auto chunkSize = taskPool.defaultWorkUnitSize(size);

		auto inputChunks = inputRange.chunks(chunkSize);
		alias Result = typeof(MapResult!(fun, Range).front);

		Result[] outputRange = new Result[size];
		auto outputChunks = outputRange.chunks(chunkSize);

		foreach(ioChunk; zip(inputChunks, outputChunks).parallel) {

			auto inputChunk = ioChunk[0];
			auto outputChunk = ioChunk[1];

			int i = 0;
			foreach(atom; inputChunk) {
				outputChunk[i++] = fun[0](atom);
			}
		}

		//-Kill me
		//-Later
		return MapResult!(a => a, Result[])(outputRange);
	}
}
