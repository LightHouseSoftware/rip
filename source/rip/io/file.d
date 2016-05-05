module rip.io.file;

protected {
	import std.stdio;

	import rip.io;
	import rip.concepts;
}

/++
+   Saves data to file with formats
+   Params:
+     surface =   input data
+			worker = 		format worker
+     name =      file name
+   Returns:
+     input data for using in UFCS
+/
S toFile(S)(S surface, const FormatWorker!(S) worker, string name) {
	return worker.save(surface, name);
}

auto fromFormatFile(S)(const FormatWorker!(S) worker, string name) {
	return worker.load(name);
}

auto fromFile(in string name) {
    File file;
    file.open(name, "r");

    return detectFormat(file).decode(file);
}

alias FW = FormatWorker!(Surface);

FW detectFormat(File file) {
	if (P6.checkOnHeader(file))
		return cast(FW)P6;

	else if(BMP.checkOnHeader(file))
		return cast(FW)BMP;

	else if(JPEG.checkOnHeader(file))
		return cast(FW)JPEG;

	else if(TGA.checkOnHeader(file))
		return cast(FW)TGA;

	else if(PNG.checkOnHeader(file))
		return cast(FW)PNG;

	assert(0, "File format is not recognized");
}
