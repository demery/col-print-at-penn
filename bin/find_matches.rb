#!/usr/bin/env ruby

require 'rubyXL'
require 'csv'
require 'tempfile'



class MMMedataXLSX
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

class BookData
  attr_accessor :bibid
  attr_accessor :directory
  attr_accessor :file_path
  attr_accessor :file_name

  # BibID Collection  Directory File Path   Link to Print at Penn     File name
  def initialize row_hash
    @bibid     = row_hash['BibID']
    @directory = row_hash['Directory']
    @file_path = row_hash['File Path']
    @file_name = row_hash['File name']
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

  private
  def blank? val
    val.nil? || val.to_s.strip.empty?
  end
end

class DirectoriesOnDisk
  def initialize path_list
    @path_list = path_list
  end

  def matches book_data
    m = @path_list.grep(/#{book_data.file_name}$/)
    return m unless m.empty?
    m = @path_list.grep(/#{book_data.file_name_for_item}$/)
    return m unless m.empty?
    @path_list.grep(/#{book_data.file_name.gsub(/_/, '')}$/)
  end
end

# mm_metadata = MMMedataXLSX.new "data/output", 2641869
# mm_metadata.write

input_csv = ARGV.shift

headers = CSV.open(input_csv, 'r') { |csv| csv.first }

File.exists? input_csv or fail "Not a valid file: '#{input_csv}'"

db_file = File.expand_path '../data/one_off_printed_dirs.txt', __FILE__
DIR_LIST = DirectoriesOnDisk.new open(db_file).readlines.map &:strip

tmpfile = Tempfile.new('foo')
tmpfile.write(open(input_csv).read.encode('UTF-8', invalid: :replace))
tmpfile.rewind
# last_index
output_csv = "#{input_csv.chomp('.csv')}-mod.csv"
CSV.open output_csv, 'wb' do |out_csv|
  out_headers = [ 'STATUS '] + headers + ['FOUND PATH']
  out_csv << out_headers

  CSV.foreach tmpfile, headers: true do |row|
    # BibID Collection  Directory File Path   Link to Print at Penn     File name
    data = BookData.new row.to_hash
    row_array = row.fields
    if data.file_name.nil?
      row_array.unshift 'NO FILE NAME'
      out_csv << row_array
      next
    end

    unless data.file_name.nil?
      matches = DIR_LIST.matches data
      row_array << matches.join(' | ')
      if matches.empty?
        row_array.unshift 'NO MATCH'
        out_csv << row_array
        puts sprintf("%-15s  %-30s", "NO MATCH", data.file_name)
      elsif matches.size > 1
        row_array.unshift 'MULTI-MATCH'
        out_csv << row_array
        puts sprintf("%-15s  %-30s --- %s", "MULTI-MATCH", data.file_name, matches.inspect)
      else
        row_array.unshift 'MATCH'
        out_csv << row_array
        puts sprintf("%-15s  %-30s --- %s", "MATCH", data.file_name, matches.first)
      end
    end
  end
end

STDERR.puts "Wrote #{output_csv}"
