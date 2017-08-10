require 'rubyXL'
require 'precol/util'

module Precol
  ##
  # Encapsulation of `MM_Metadata.xlsx` file writer.
  #
  class MMMetadataXLSX
    attr_accessor :dest_dir, :bibid, :xlsx_name

    ##
    # `dest_dir` -- where to put the file
    #
    # `bibid` -- the BibID to use
    #
    # `xlsx_name` -- base name of output file [default=MM_Metadata.xlsx]
    def initialize dest_dir, bibid, xlsx_name='MM_Metadata.xlsx'
      @dest_dir  = dest_dir
      @bibid = bibid
      @xlsx_name = xlsx_name
    end

    def outfile
      File.join dest_dir, xlsx_name
    end

    def write
      workbook = RubyXL::Workbook.new
      worksheet = workbook['Sheet1']
      worksheet.add_cell 0, 0, "BibID"
      worksheet.add_cell 1, 0, Util.new_bibid(bibid)
      workbook.write outfile
    end
  end
end