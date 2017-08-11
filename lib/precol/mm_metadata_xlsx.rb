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

    ##
    # `dest_dir` -- where to put the file
    #
    # `bibid` -- the BibID to use
    #
    # `xlsx_name` -- base name of output file [default=MM_Metadata.xlsx]
    def initialize dest_dir, bibid, options={}
      @dest_dir  = dest_dir
      @bibid = bibid
      @xlsx_name = options[:xlsx_name] || 'MM_Metadata.xlsx'
      @clobber = options[:clobber] || false
      @quiet = options[:quiet].nil? ? true : options[:quiet]
    end

    def outfile
      File.join dest_dir, xlsx_name
    end

    def write
      if File.exists? outfile
        if clobber?
          message { sprintf "Overwriting existing file '%s'", outfile }
        else
          message { sprintf "Not overwriting existing file '%s'", outfile }
          return
        end
      end
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