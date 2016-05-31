module rip.parallelism.pmap;

import std.algorithm;
import std.parallelism;
import std.range;

template pmap(fun...) {
	auto pmap(Range) (Range inputRange) {

		alias RangeElementType = ElementType!Range;

		auto chunkSize = taskPool.defaultWorkUnitSize(inputRange.length);

		auto inputChunks = inputRange.chunks(chunkSize);
		alias Result = typeof(MapResult!(fun, Range).front);

		auto size = inputRange.length;

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

		/*struct PMapResult(Result) {
			Result[] range;

			this(Result[] range) {
				this.range = range;
			}

			auto front() {
				return range[0];
			}

			void popFront() {
				range = range[1..$];
			}

			auto size() {
				return range.length;
			}

			auto length() {
				return range.length;
			}

			bool empty() {
				return range.length == 0;
			}

			auto save() {
				return this;
			}
		}*/

		return MapResult!(a => a, Result[])(outputRange);
	}
}
