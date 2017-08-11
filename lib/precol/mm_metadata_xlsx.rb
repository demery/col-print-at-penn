require 'rubyXL'
require 'precol/util'
require 'precol/message'
require 'precol/clobberable'

module Precol
  ##
  # Encapsulation of `MM_Metadata.xlsx` file writer.
  #
  class MMMetadataXLSX
    include Precol::Messsage
    include Precol::Clobberable

    attr_accessor :dest_dir, :bibid, :xlsx_name

    XLSX_NAME = 'MM_Metadata.xlsx'

    ##
    # `dest_dir` -- where to put the file
    #
    # `bibid` -- the BibID to use
    #
    def initialize dest_dir, bibid, options={}
      @dest_dir  = dest_dir
      @bibid     = bibid
      @clobber   = options[:clobber]
      @quiet     = options[:quiet]
    end

    def outfile
      File.join dest_dir, XLSX_NAME
    end

    def write
      writable? outfile or return false

      workbook = RubyXL::Workbook.new
      worksheet = workbook['Sheet1']
      worksheet.add_cell 0, 0, "BibID"
      worksheet.add_cell 1, 0, Util.new_bibid(bibid)
      workbook.write outfile
      message { sprintf "Wrote '%s'", outfile }
      true
    end
  end
end