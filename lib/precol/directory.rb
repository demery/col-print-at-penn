require 'precol/mm_metadata_xlsx'
require 'precol/mm_text_file'

module Precol
  ##
  # Directory to prepare for Colenda ingest. Creates `MM_Metadata.xlsx` and
  # `sha1-ready.txt` in the directory at `path`. `old_bibid` is used entered
  # as `BibID` in the `MM_Metadata.xlsx` file.
  #
  # Note: Will NOT work with new style bibid.
  # Note: Does not create `mm-ready.txt` file.
  class Directory
    attr_reader :path, :old_bibid, :verbose

    ##
    # `path` -- the destination folder
    #
    # `old_bibid` -- old style 'short' bibid; added to XLSX as
    #                `99#{old_bibid}3503681`
    #
    # `verbose` -- print activity [default=false]
    def initialize path, old_bibid, verbose=false
      @path      = path
      @old_bibid = old_bibid
      @verbose   = verbose
    end

    def prep
      xlsx = Precol::MMMetadataXLSX.new path, old_bibid
      xlsx.write
      puts "Wrote '#{xlsx.outfile}'" if verbose

      sha1_ready = Precol::MMTextFile.new 'sha1-ready.txt', path
      sha1_ready.write
      puts "Wrote '#{sha1_ready.outfile}'" if verbose
    end
  end
end