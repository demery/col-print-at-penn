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
    attr_reader :path, :old_bibid, :quiet, :clobber

    ##
    # `path` -- the destination folder
    #
    # `old_bibid` -- old style 'short' bibid; added to XLSX as
    #                `99#{old_bibid}3503681`
    #
    # `quiet` -- be silent
    def initialize path, old_bibid, options={}
      @path      = path
      @old_bibid = old_bibid
      @quiet     = options[:quiet] || false
      @clobber   = options[:clobber] || false
    end

    def prep
      write_metadata_xslx and write_sha1_ready
    end

    def write_metadata_xslx
      xlsx = Precol::MMMetadataXLSX.new path, old_bibid, quiet: quiet, clobber: clobber
      xlsx.write
    end

    def write_sha1_ready
      sha1_ready = Precol::MMTextFile.new 'sha1-ready.txt', path, quiet: quiet, clobber: clobber
      sha1_ready.write
    end
  end
end