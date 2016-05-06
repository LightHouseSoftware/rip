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
      *  surface
      *  color
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
   *   transforms(rip.dsp)
      *  Haar's
      *  Hadamard's
      *  Slant's

The most funcs has their analogs for working with ranges.

## In planes
   *  add more operations for histograms
   *  add more drawing funcs
   *  add more formats into IO package
   *  add 'vision' package for digital vision
   *  clean code
   *  optimize code

If you have advices, please, create Issue. You can help us!

## Contributors 
   ImPureD Team, LightHouse Software
   
   *  Oleg Baharev (aka aquaratixc)
   *  Roman Vlasov

## How to use RIP?

Package in your `dub.json`:
```d
   {
      "dependencies": {
        "rip": "~>0.0.2"
      }
   }
```
## Dependencies

RIP needs dlib library for loading jpeg/png/bmp/tga files.
WARNING: image can be saved ONLY in ppm/pam/png formats.
