# -*- coding: utf-8 -*-

require_relative './spec_helper'

describe PdfboxTextExtraction do

  describe ".run" do

    let(:pdf_file_path) { File.expand_path("../test_file.pdf", __FILE__) }

    it "extracts full page text" do
      extracted_text = PdfboxTextExtraction.run(pdf_file_path)
      extracted_text.must_equal(
        [
          'This is a test pdf for the pdfbox_text_extraction Ruby gem.',
          'Text at the top of the page.',
          'Text in the middle of the page.',
          'Text at the bottom of the page.',
          '',
        ].join("\n")
      )
    end

    it "extracts crop area text" do
      extracted_text = PdfboxTextExtraction.run(
        pdf_file_path,
        {
          crop_x: 0,
          crop_y: 3.0,
          crop_width: 8.5,
          crop_height: 6.0,
        }
      )
      extracted_text.must_equal("Text in the middle of the page.\n\n")
    end

  end

end
