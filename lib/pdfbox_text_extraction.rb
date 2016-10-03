# Java libraries
require 'java'
require_relative "../vendor/pdfbox/commons-logging-1.2/commons-logging-1.2.jar"
require_relative "../vendor/pdfbox/fontbox-2.0.3.jar"
require_relative "../vendor/pdfbox/pdfbox-2.0.3.jar"

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
  # @option options [Float] crop_x crop area top left corner x-coordinate
  # @option options [Float] crop_y crop area top left corner y-coordinate
  # @option options [Float] crop_width crop area width
  # @option options [Float] crop_height crop area height
  # @option options [Float] average_char_tolerance
  # @option options [Float] drop_threshold
  # @option options [Float] indent_threshold
  # @option options [Float] spacing_tolerance
  # @option options [Boolean] sort_by_position
  # @option options [String] line_separator
  # @option options [String] page_end
  # @option options [String] page_start
  # @option options [String] paragraph_end
  # @option options [String] paragraph_start
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
      configure_text_extraction_params(text_stripper, options)

      pd_doc.getPages.each do |page|
        text_stripper.extractRegions(page)
        # Get the body text of the current page
        all_text << text_stripper.getTextForRegion("bodyText")
      end
    else
      # No crop options given, extract all text
      text_stripper = PDFTextStripper.new
      configure_text_extraction_params(text_stripper, options)
      all_text << text_stripper.getText(pd_doc)
    end

    pd_doc.close

    all_text
  end

  # Sets params on text_stripper.
  # @param text_stripper [PDFTextStripper]
  def self.configure_text_extraction_params(text_stripper, options)

    # *****************************************************
    # Extraction thresholds and tolerances

    # Set the character width-based tolerance value that is used to estimate
    # where spaces in text should be added.
    # Default: 0.30000001192092896
    if(o = options[:average_char_tolerance])
      text_stripper.setAverageCharTolerance(o)
    end

    # Set the minimum whitespace, as a multiple of the max height of the current
    # characters beyond which the current line start is considered to be a
    # paragraph start.
    # Default: 2.5
    if(o = options[:drop_threshold])
      text_stripper.setDropThreshold(o)
    end

    # Set the multiple of whitespace character widths for the current text
    # which the current line start can be indented from the previous line
    # start beyond which the current line start is considered to be a
    # paragraph start.
    # Default: 2.0
    if(o = options[:indent_threshold])
      text_stripper.setIndentThreshold(o)
    end

    # Set the space width-based tolerance value that is used to estimate where
    # spaces in text should be added.
    # Default: 0.5
    if(o = options[:spacing_tolerance])
      text_stripper.setSpacingTolerance(o)
    end

    # *****************************************************
    # Sort order

    # The order of the text tokens in a PDF file may not be in the same as
    # they appear visually on the screen.
    # Default: false
    if !(o = options[:sort_by_position]).nil? # Allow override of false
      text_stripper.setSortByPosition(o)
    end

    # *****************************************************
    # Separator tokens

    # Set the desired line separator for output text.
    # Default: "\n"
    if(o = options[:line_separator])
      text_stripper.setLineSeparator(o)
    end

    # Set the string which will be used at the end of a page.
    # Default: ""
    if(o = options[:page_end])
      text_stripper.setPageEnd(o)
    end

    # Set the string which will be used at the end of a page.
    # Default: ""
    if(o = options[:page_start])
      text_stripper.setPageStart(o)
    end

    # Set the string which will be used at the end of a paragraph.
    # Default: ""
    if(o = options[:paragraph_end])
      text_stripper.setParagraphEnd(o)
    end

    # Set the string which will be used at the end of a paragraph.
    # Default: ""
    if(o = options[:paragraph_start])
      text_stripper.setParagraphStart(o)
    end

  end

end
