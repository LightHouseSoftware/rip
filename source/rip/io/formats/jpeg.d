module rip.io.formats.jpeg;

private {
	import std.stdio : File;
	import std.string;

	import rip.concepts;
	import rip.io.interfaces;

	import rip.io.dlib;
}

public:
static const auto JPEG = new JPEGWorker;

private:

static final class JPEGWorker : FormatWorker!(Surface) {

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
		return buff == [0xFF, 0xD8];
	}

	override Surface load(in string filename) const {
		import rip.io.dlib;

		return superImageToSurface(loadJPEG(filename));
	}
}
