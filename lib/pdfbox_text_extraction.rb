# Java libraries
require 'java'
require_relative "../vendor/pdfbox/commons-logging-1.2/commons-logging-1.2.jar"
require_relative "../vendor/pdfbox/fontbox-2.0.0.jar"
require_relative "../vendor/pdfbox/pdfbox-2.0.0.jar"

require 'pdfbox_text_extraction/version'

class PdfboxTextExtraction

  java_import java.io.File;
  java_import org.apache.pdfbox.cos.COSDocument;
  java_import org.apache.pdfbox.io.RandomAccessFile;
  java_import org.apache.pdfbox.pdfparser.PDFParser;
  java_import org.apache.pdfbox.pdmodel.PDDocument;
  java_import org.apache.pdfbox.text.PDFTextStripper;

  # For extractor by area
  java_import java.awt.geom.Rectangle2D;
  java_import org.apache.pdfbox.pdmodel.PDPage;
  java_import org.apache.pdfbox.text.PDFTextStripperByArea;

  # Runs text extraction and returns extracted text as string.
  # Optionally can extract text from crop area only if crop area dimensions
  # are given. All crop area dimensions are in inches.
  #
  # @param path_to_pdf [String]
  # @param options [Hash, optional]
  # @param option [Float] crop_x crop area top left corner x-coordinate
  # @param option [Float] crop_y crop area top left corner y-coordinate
  # @param option [Float] crop_width crop area width
  # @param option [Float] crop_height crop area height
  # @return [String] the extracted text
  def self.run(path_to_pdf, options={})
    file = File.new(path_to_pdf)
    pd_doc = PDDocument.load(file)
    text_stripper = nil
    all_text = ''
    if [:crop_x, :crop_y, :crop_width, :crop_height].any? { |e| options[e] }
      # crop options given, extract from crop area only
      res = 72
      body_text_rect = Rectangle2D::Float.new(
        (options[:crop_x] * res),
        (options[:crop_y] * res),
        (options[:crop_width] * res),
        (options[:crop_height] * res)
      )
      text_stripper = PDFTextStripperByArea.new
      text_stripper.addRegion("bodyText", body_text_rect)
      configure_text_extraction_params(text_stripper)

      pd_doc.getPages.each do |page|
        text_stripper.extractRegions(page)
        # Get the body text of the current page
        all_text << text_stripper.getTextForRegion("bodyText")
      end
    else
      # No crop options given, extract all text
      text_stripper = PDFTextStripper.new
      configure_text_extraction_params(text_stripper)
      all_text << text_stripper.getText(pd_doc)
    end

    pd_doc.close

    all_text
  end

  # Sets params on text_stripper.
  # @param text_stripper [PDFTextStripper]
  def self.configure_text_extraction_params(text_stripper)

    # *****************************************************
    # Extraction thresholds and tolerances

    # Set the character width-based tolerance value that is used to estimate
    # where spaces in text should be added.
    # Default: 0.30000001192092896
    # text_stripper.setAverageCharTolerance(0.30000001192092896)

    # Set the minimum whitespace, as a multiple of the max height of the current
    # characters beyond which the current line start is considered to be a
    # paragraph start.
    # Default: 2.5
    # text_stripper.setDropThreshold(2.5)

    # Set the multiple of whitespace character widths for the current text
    # which the current line start can be indented from the previous line
    # start beyond which the current line start is considered to be a
    # paragraph start.
    # Default: 2.0
    # text_stripper.setIndentThreshold(2.0)

    # Set the space width-based tolerance value that is used to estimate where
    # spaces in text should be added.
    # Default: 0.5
    text_stripper.setSpacingTolerance(0.3)

    # *****************************************************
    # Sort order

    # The order of the text tokens in a PDF file may not be in the same as
    # they appear visually on the screen.
    # Default: false
    text_stripper.setSortByPosition(false)

    # *****************************************************
    # Separator tokens

    # Set the desired line separator for output text.
    # Default: "\n"
    # text_stripper.setLineSeparator("\n")

    # Set the string which will be used at the end of a page.
    # Default: ""
    # text_stripper.setPageEnd("<<page-end>>")

    # Set the string which will be used at the end of a page.
    # Default: ""
    # text_stripper.setPageStart("<<page-start>>")

    # Set the string which will be used at the end of a paragraph.
    # Default: ""
    # text_stripper.setParagraphEnd("<<paragraph-end>>")

    # Set the string which will be used at the end of a paragraph.
    # Default: ""
    # text_stripper.setParagraphStart("<<paragraph-start>>")

  end

end
