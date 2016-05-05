//Возможно, этому модулю подойдет другое имя
module rip.concepts.makers;

protected {
    import std.stdio;
    import std.math;

    import rip.concepts.color;
}

RGBColor    makeHSV(in float h, lazy float s, lazy float v)
in {
    if(!isNaN(h)) {
        assert(h >= 0 && h <= 360,
            "H must belong to the segment [0, 360] or be NAN");
        assert(s >= 0 && s <= 1,
            "S must belong to the segment [0, 1]");
        assert(v >= 0 && v <= 1,
            "V must belong to the segment [0, 1]");
    }
}
body {
    if(isNaN(h))
        return new RGBColor(0, 0, 0);
    else {

        float c = v * s;
        float _h = h / 60;
        float x = c * (1 - abs(_h % 2 - 1));
        float m = v - c;

        float _r = 0, _g = 0, _b = 0;

        if(_h >= 0 && _h < 1) {
            _r = c;
            _g = x;
        }
        else if(_h < 2) {
            _r = x;
            _g = c;
        }
        else if(_h < 3) {
            _g = c;
            _b = x;
        }
        else if(_h < 4) {
            _g = x;
            _b = c;
        }
        else if(_h < 5) {
            _r = x;
            _b = c;
        }
        else {
            _r = c;
            _b = x;
        }

        return new RGBColor(
            round((_r + m) * 255),
            round((_g + m) * 255),
            round((_b + m) * 255));
    }

    assert(0);
}

//Две практически одинаковые ф-ции в модуле. Надо
//подумать об их объединении
RGBColor    makeHSL(in float h, lazy float s, lazy float l)
in {
    if(!isNaN(h)) {
        assert(h >= 0 && h < 360,
            "H must belong to the segment [0, 360) or be NAN");
        assert(s >= 0 && s <= 1,
            "S must belong to the segment [0, 1]");
        assert(l >= 0 && l <= 1,
            "L must belong to the segment [0, 1]");
    }
}
body {
    if(isNaN(h))
        return new RGBColor(0, 0, 0);
    else {

        float c = (1 - abs(2 * l - 1)) * s;
        float _h = h / 60;
        float x = c * (1 - abs(_h % 2 - 1));
        float m = l - c / 2;

        float _r = 0, _g = 0, _b = 0;

        if(_h >= 0 && _h < 1) {
            _r = c;
            _g = x;
        }
        else if(_h < 2) {
            _r = x;
            _g = c;
        }
        else if(_h < 3) {
            _g = c;
            _b = x;
        }
        else if(_h < 4) {
            _g = x;
            _b = c;
        }
        else if(_h < 5) {
            _r = x;
            _b = c;
        }
        else {
            _r = c;
            _b = x;
        }

        return new RGBColor(
            round((_r + m) * 255),
            round((_g + m) * 255),
            round((_b + m) * 255));
    }

    assert(0);
}

RGBColor makeCMYK(in float c, in float m, in float y, in float k)
in {
    assert(c >= 0 && c <= 1,
        "C must belong to the segment [0, 1]");
    assert(m >= 0 && m <= 1,
        "M must belong to the segment [0, 1]");
    assert(y >= 0 && y <= 1,
        "Y must belong to the segment [0, 1]");
    assert(k >= 0 && k <= 1,
        "K must belong to the segment [0, 1]");
}
body {
    return new RGBColor(
        round(255 * (1 - c) * (1 - k)),
        round(255 * (1 - m) * (1 - k)),
        round(255 * (1 - y) * (1 - k)));
}

RGBColor makeXYZ(float x, float y, float z)
in {
    assert(x >= 0 && x <= 95.047f,
        "x must belong to the segment [0, 95.047]");
    assert(y >= 0 && y <= 100,
        "y must belong to the segment [0, 100]");
    assert(z >= 0 && z <= 108.883f,
        "z must belong to the segment [0, 108.883]");
}
body {
    x /= 100.0f;
    y /= 100.0f;
    z /= 100.0f;

    auto r = x * 3.2406 + y * -1.5372 + z * -0.4986;
    auto g = x * -0.9689 + y * 1.8758 + z * 0.0415;
    auto b = x * 0.0557 + y * -0.2040 + z * 1.0570;

    r = r > 0.0031308 ? 1.055 * pow(r, 1 / 2.4) - 0.055 : 12.92 * r;
    g = g > 0.0031308 ? 1.055 * pow(g, 1 / 2.4) - 0.055 : 12.92 * g;
    b = b > 0.0031308 ? 1.055 * pow(b, 1 / 2.4) - 0.055 : 12.92 * b;

    return new RGBColor(r * 255.0f, g * 255.0f, b * 255.0f);
}

RGBColor makeLAB(float l, float a, float b)
in {}
body {
    const float E = 0.008856f;
    const float K = 903.3f;

    auto wX = 95.047f;
    auto wY = 100.0f;
    auto wZ = 108.883f;

    float _y = (l + 16) / 116;
    float _x = a / 500 + _y;
    float _z = _y - b / 200;

    auto y3 = pow(_y, 3);
    auto x3 = pow(_x, 3);
    auto z3 = pow(_z, 3);

    if(y3 > E)
        _y = y3;
    else
        _y = (_y - 16 / 116 ) / 7.787;

    if(x3 > E)
        _x = x3;
    else
        _x = (_x - 16 / 116 ) / 7.787;

    if(z3 > E)
        _z = z3;
    else
        _z = (_z - 16 / 116 ) / 7.787;

    _x *= wX;
    _y *= wY;
    _z *= wZ;

    return makeXYZ(_x, _y, _z);
}

unittest {
    auto color = makeHSV(72, 0.83, 0.73);

    assert(color.red!ubyte == 155);
    assert(color.green!ubyte == 186);
    assert(color.blue!ubyte == 32);

    float emptyFloat;
    color = makeHSV(emptyFloat, 0.45, 0.6);

    assert(color.red!ubyte == 0);
    assert(color.green!ubyte == 0);
    assert(color.blue!ubyte == 0);
}
