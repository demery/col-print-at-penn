module Precol
  ##
  # Encapsulation of `sha1-ready.txt`, `mm-ready.txt` file write. Will create
  # a text file of any name in any directory.
  class MMTextFile
    ##
    # `file_name` -- base name of the file to write
    #
    # `dest_dir` -- where to put the file [default=.]
    def initialize file_name, dest_dir='.'
      @file_name = file_name
      @dest_dir = dest_dir
    end

    def outfile
      File.join @dest_dir, @file_name
    end

    ##
    # Write content to specified file. Clobbers existing file of same name.
    #
    # `content` -- what to write to the file [default='']
    def write content=''
      File.open(outfile, "w") { |f| f.puts content }
    end
  end
end