module Precol
  class BookData
    attr_accessor :bibid
    attr_accessor :directory
    attr_accessor :file_path
    attr_accessor :file_name
    attr_accessor :found_path
    attr_accessor :status

    # BibID Collection  Directory File Path   Link to Print at Penn     File name
    def initialize row_hash
      @status     = row_hash['STATUS']
      @bibid      = row_hash['BibID']
      @directory  = row_hash['Directory']
      @file_path  = row_hash['File Path']
      @file_name  = row_hash['File name']
      @found_path = row_hash['FOUND PATH']
    end

    def dir_path start='/Volumes'
      return if blank? directory
      File.join start, directory.gsub(/\\/, '/')
    end

    def full_path start='/Volumes'
      return if blank?(directory) && blank?(file_path)
      return File.join start, file_path.gsub(/\\/, '/') unless blank? file_path
      return File.join dir_path(start), file_name unless blank? file_name
    end

    def file_name_for_item
      # return file_name unless file_name =~ /_n\d+$/
      file_name.sub(/_(n[-\d]*\d|n\d+and\d+)$/, '/\1')
    end

    def path_array
      @found_path.to_s.split('|').map &:strip
    end

    def path_count
      path_array.size
    end

    private
    def blank? val
      val.nil? || val.to_s.strip.empty?
    end
  end
end