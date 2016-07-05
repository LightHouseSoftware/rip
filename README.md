# RIP

RIP is a library for complex image processing.

## License

GPLv3

## Features
   * I/O
      * JPEG(based on dlib, only loading)
      * TGA(based on dlib, only loading)
      * BMP(based on dlib, only loading)
      * PNG(based on dlib, loading/saving)
      * simple and convenient intermediate format (PPM P6)
      * PPM(loading/saving)
      * PAM(loading savind)
   * processing
      *  grayscale
      *  negative
      *  operations with bit set
      *  colorization
      *  rough of pixels
      *  order filters(4 filters)
      *  linear filters(11 filters)
      *  convolution
   *  analysis
      *  operations with histogram
   *  concepts
      *  surface (generalized image type)
      *  surfaces addition, subtraction, multiplication and other arithmetic operations
      *  logical operation with surfaces
      *  gamma correction and inverting of image
      *  color
      *  color arithmetic
      *  generation RGBColor from others color formats
      *  useful math functions
      *  ranges
      *  templates
      *  channels for working with pixels on channel level
   *  draw
      *  IFS systems
      *  L-systems
      *  drawing math funcs
      *  drawing primitives
      *  turtle
      *  another interest graphical procedures
   *   transforms(rip.dsp)
      *  Haar's
      *  Hadamard's
      *  Slant's

The most funcs has their analogs for working with ranges.

## In plans
   *  add more operations for histograms
   *  add more drawing funcs
   *  add more formats into IO package
   *  add 'vision' package for digital vision
   *  clean code
   *  optimize code
   *  write documantation

If you have advices, please, create Issue. You can help us!

## Contributors
   ImPureD Team, LightHouse Software

   *  Oleg Baharev (aka aquaratixc)
   *  Roman Vlasov

## Documentation

    Documantaion available only for package "concepts" on site

    http://lighthousesoftware.github.io/rip

## How to use RIP?

Package in your `dub.json`:
```d
   {
      "dependencies": {
        "rip": "~>0.0.3"
      }
   }
```
## Dependencies

RIP needs dlib library for loading jpeg/png/bmp/tga files.
WARNING: image can be saved ONLY in ppm/pam/png formats.
