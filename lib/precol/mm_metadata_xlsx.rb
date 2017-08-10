require 'rubyXL'

module Precol
  class MMMetadataXLSX
    attr_accessor :dest_dir, :old_bibid

    def initialize dest_dir, old_bibid
      @dest_dir  = dest_dir
      @old_bibid = old_bibid
    end

    def new_bibid
      "99#{old_bibid}3503681"
    end

    def outfile
      File.join dest_dir, 'MM_Metadata.xlsx'
    end

    def write
      workbook = RubyXL::Workbook.new
      worksheet = workbook['Sheet1']
      worksheet.add_cell 1, 0, new_bibid
      workbook.write outfile
    end
  end
end