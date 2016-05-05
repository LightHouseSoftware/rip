module rip.io.formats.pam;

private {
	import std.algorithm;
	import std.conv : parse;

	import std.stdio : File;
	import std.string;
	import std.algorithm;
	import std.stdio;

	import rip.io.interfaces;
	import rip.concepts;
}

public:
static const auto PAM = new PamWorker;

private:

static final class PamWorker : FormatWorker!(Surface) {
	override Surface save(in Surface surface, in string filename) const {
		File file;

		with (file)
		{
			open(filename, "w");
			writeln("P7");
			writeln("WIDTH ", surface.getWidth!uint);
			writeln("HEIGHT ", surface.getHeight!uint);
			writeln("DEPTH 3");
			writeln("MAXVAL 255");
			writeln("TUPLTYPE RGB");
			writeln("ENDHDR");

			//раскомментировать, когда ситуация с этим шаблоном разрешится
			//mixin colorsToFile;

			void toFile(in RGBColor color)  {
				file.write(
					color.red!char,
					color.green!char,
					color.blue!char);
			}

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
			if (readln().strip == "P7")
			{
				size_t width, height;
				auto strData = readln.split;

				while(strData[0] != "ENDHDR") {
					switch(strData[0]) {
						case "WIDTH": width = parse!size_t(strData[1]); break;
						case "HEIGHT": height = parse!size_t(strData[1]); break;
						case "DEPTH": {
							if(parse!ubyte(strData[1]) != 3)
								assert(0, "P7: Only files with DEPTH 3 are supported");
						} break;
						case "MAXVAL": {
							if(parse!uint(strData[1]) != 255)
								assert(0, "P7: Only files with MAXVAL 255 are supported");
						} break;
						case "TUPLTYPE": {
							if(strData[1] != "RGB")
								assert(0, "P7: Only files with TUPLTYPE RGB are supported");
						} break;

						default: break;
					}

					strData = readln.split;
				}

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

		assert(0, "PAM: Error. Decoding terminated.");
	}

	override bool checkOnHeader(File file) const {
		ubyte[2] buff;
		file.rawRead(buff);
		file.seek(0);
		return buff == [0x50, 0x37];
	}

	override Surface load(in string name) const {
		return null;
	}
}
