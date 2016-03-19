# PDFBox text extraction

This gem lets you extract plain text from PDF documents. It is a Jruby wrapper for the [Apache PDFBox](https://pdfbox.apache.org/) library.

## Installation

Add this line to your application's Gemfile:

    gem 'pdfbox_text_extraction'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pdfbox_text_extraction

## Usage

To extract all text on every page:

    extracted_text = PdfboxTextExtraction.run(path_to_pdf)

To extract text inside a crop area:

    extracted_text = PdfboxTextExtraction.run(
      path_to_pdf,
      {
        crop_x: 0, # crop area top left corner x-coordinate
        crop_y: 1.0, # crop area top left corner y-coordinate
        crop_width: 8.5, # crop area width
        crop_height: 9.4, # crop area height
      }
    )

## Contributing

1. Fork it ( https://github.com/jhund/pdfbox_text_extraction/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Resources

* [Source code (github)](https://github.com/jhund/pdfbox_text_extraction)
* [Issues](https://github.com/jhund/pdfbox_text_extraction/issues)
* [Rubygems.org](http://rubygems.org/gems/pdfbox_text_extraction)

### License

[MIT licensed](https://github.com/jhund/pdfbox_text_extraction/blob/master/LICENSE.txt).

### Copyright

Copyright (c) 2016 Jo Hund. See [(MIT) LICENSE](https://github.com/jhund/pdfbox_text_extraction/blob/master/LICENSE.txt) for details.
