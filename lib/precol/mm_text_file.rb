require 'precol/message'
require 'precol/clobberable'

module Precol
  ##
  # Encapsulation of `sha1-ready.txt`, `mm-ready.txt` file write. Will create
  # a text file of any name in any directory.
  class MMTextFile
    include Precol::Messsage
    include Precol::Clobberable

    ##
    # `file_name` -- base name of the file to write
    #
    # `dest_dir` -- where to put the file [default=.]
    #
    # Options:
    #
    # `:clobber` -- whether to overwrite an existing file [default=false]
    #
    # `:quiet` -- be silent
    def initialize file_name, dest_dir, options={}
      @file_name = file_name
      @dest_dir  = dest_dir
      @clobber   = options[:clobber]
      @quiet     = options[:quiet]
    end

    def outfile
      File.join @dest_dir, @file_name
    end

    ##
    # Write content to specified file. Clobbers existing file of same name.
    #
    # `content` -- what to write to the file [default='']
    def write content=''
      writable? outfile or return false

      File.open(outfile, "w") { |f| f.puts content }
      message { sprintf "Wrote '%s'", outfile }
      true
    end
  end
end