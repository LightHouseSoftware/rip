module rip.io.formats.png;

private {
	import std.stdio : File;
	import std.string;

	import rip.concepts;
	import rip.io.interfaces;

	import rip.io.dlib;
}

public:
static const auto PNG = new PNGWorker;

private:

static final class PNGWorker : FormatWorker!(Surface) {

	override Surface save(in Surface surface, in string filename) const {
		import rip.io.dlib;

		savePNG(surfaceToSuperImage(surface), filename);

		return cast(Surface)surface;
	}
	//вернёт false, если всё прошло успешно

	override Surface decode(File file) const {
		return this.load(file.name);
	}

	override bool checkOnHeader(File file) const {
		ubyte[8] buff;
		file.rawRead(buff);
		file.seek(0);
		return buff == [137, 80, 78, 71, 13, 10, 26, 10];
	}

	override Surface load(in string filename) const {
		import rip.io.dlib;

		return superImageToSurface(loadPNG(filename));
	}
}
