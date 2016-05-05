module rip.io.formats.bmp;

private {
	import std.stdio : File;
	import std.string;

	import rip.concepts;
	import rip.io.interfaces;

	import rip.io.dlib;
}

public:
static const auto BMP = new BMPWorker;

private:

static final class BMPWorker : FormatWorker!(Surface) {

	override Surface save(in Surface surface, in string filename) const {
		import rip.io.dlib;

		saveImage(surfaceToSuperImage(surface), filename);

		return cast(Surface)surface;
	}
	//вернёт false, если всё прошло успешно

	override Surface decode(File file) const {
		return this.load(file.name);
	}

	override bool checkOnHeader(File file) const {
		ubyte[2] buff;
		file.rawRead(buff);
		file.seek(0);
		return buff == [0x42, 0x4D];
	}

	override Surface load(in string filename) const {
		import rip.io.dlib;

		return superImageToSurface(loadBMP(filename));
	}
}
