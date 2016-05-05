module rip.io.dlib;

private {
    import rip.io;
}

public:

//Если привязка используется, то и доступ к библеотеке должен присутствовать
import dlib.image;

//alias superImageToSurface = convert!(Surface);
Surface superImageToSurface(SuperImage image) {
    auto surface = new Surface(image.width, image.height);

    foreach(i; 0..image.width) {
        foreach(j; 0..image.height) {
            surface[i, j] = color4ToRgbColor(image[i, j]);
        }
    }

    return surface;
}

SuperImage surfaceToSuperImage(in Surface _surface) {
    //opIndex должна быть const, при исправлении строчку ниже удалить
    auto surface = cast(Surface)_surface;

    auto _image = image(surface.getWidth!uint, surface.getHeight!uint, 4, 8);

    foreach(i; 0.._image.width) {
        foreach(j; 0.._image.height) {
            _image[i, j] = rgbColorToColor4(surface[i, j]);
        }
    }

    return _image;
}

RGBColor color4ToRgbColor(in Color4f color) {
    return new RGBColor(color.r * 255, color.g * 255, color.b * 255);
}

Color4f rgbColorToColor4(in RGBColor color) {
    return Color4f( color.red!float / 255,
                     color.green!float / 255,
                     color.blue!float / 255, 1);
}
