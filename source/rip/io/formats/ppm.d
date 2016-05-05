module rip.io.formats.ppm;

private {
	import std.algorithm;
	import std.conv : parse;

	import std.stdio : File;
	import std.string;

	import rip.concepts;
	import rip.io.interfaces;
}

public:
static const auto P6 = new P6Worker;

private:

static final class P6Worker : FormatWorker!(Surface) {

	override Surface save(in Surface surface, in string filename) const {
		File file;

		with (file)
		{
			open(filename, "w");
			writeln("P6");
			writeln(surface.getWidth!uint, " ", surface.getHeight!uint);
			writeln(255);

			//раскомментировать, когда ситуация с этим шаблоном разрешится
			//mixin colorsToFile;

			alias toFile = (in a) => file.write(
				a.red!char,
				a.green!char,
				a.blue!char);

			surface
				.getPixels()
					.each!toFile;

			close();
		}

		return cast(Surface)surface;
	}
	//вернёт false, если всё прошло успешно

	override Surface decode(File file) const {
		with (file) {
			if (readln().strip == "P6")
			{
				auto imageSize = readln.split;
				auto width = parse!size_t(imageSize[0]);
				auto height = parse!size_t(imageSize[1]);
				readln();
				auto buffer = new ubyte[width * 3];

				Surface surface = new Surface(width, height);

				for (size_t i = 0; i < height; i++)
				{
					file.rawRead!ubyte(buffer);
					for (size_t j = 0; j < width; j++)
					{

						surface[j + i * width] = new RGBColor(
							buffer[j * 3],
							buffer[j * 3 + 1],
							buffer[j * 3 + 2]
							);
					}
				}

				close();

				return surface;
			}
		}

		assert(0, "PPM: Error. Decoding terminated.");
	}

	override bool checkOnHeader(File file) const {
		ubyte[2] buff;
		file.rawRead(buff);
		file.seek(0);
		return buff == [0x50, 0x36];
	}

	override Surface load(in string filename) const {
		File file;

		file.open(filename, "r");

		return this.decode(file);
	}
}
