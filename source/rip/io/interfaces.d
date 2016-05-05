module rip.io.interfaces;

import std.stdio;

/++
+   Base interface for format workers
+   Can be used not only for Surface
+   Example:
+   ------------
+   FormatWorker!int loader = new ...
+   int answer = 42;
+   int question;

+   loader.save(42, "output.txt");
+   question = loader.load("universe.txt")
+   ------------
+/
interface FormatWorker(T) {
    /++
    +   Saves data to file
    +   Params:
    +     surface =   input data
    +     name =      file name
    +   Returns:
    +     input data for using in UFCS
    +
    +/
    T save(in T surface, in string name) const;
    //ошибка должна выбивать исключение

    /++
    +   Loads data from file
    +   Params:
    +     filename =  file name
    +   Returns:
    +     loaded data
    +/
    T load(in string name) const;

    /++
    +   Decodes data from file
    +   Params:
    +     file =   file
    +   Returns:
    +     decoded data from file
    +/
    T decode(File file) const;

    /++
    +   Check file for header
    +   Params:
    +     file =   file
    +   Returns:
    +     'true' if file have header of this format
    +/
    bool checkOnHeader(File file) const;
}

//этому шаблону здесь не место
mixin template colorsToFile() {
    import std.stdio;
    void toFile(RGBColor color)  {
        file.write(
                    color.red!char,
                    color.green!char,
                    color.blue!char);
    }

    /*surface.getPixelsRange().each!toFile;*/
    auto range = surface.getPixels();

    import std.algorithm;
    /*each!toFile(range);*/
    //Бага?
    //source/io/interfaces.d(25,16): Error: function declaration without return type. (Note that constructors are always named 'this')
    //source/io/interfaces.d(25,23): Error: no identifier for declarator each!toFile(range)
}
