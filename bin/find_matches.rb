#!/usr/bin/env ruby

$:.unshift File.expand_path '../../lib', __FILE__
require 'precol'
require 'precol/util'
require 'csv'
require 'tempfile'

include Precol::Util

# mm_metadata = MMMedataXLSX.new "data/output", 2641869
# mm_metadata.write

input_csv = ARGV.shift

headers = CSV.open(input_csv, 'r') { |csv| csv.first }

File.exists? input_csv or fail "Not a valid file: '#{input_csv}'"

db_file = File.expand_path '../../data/one_off_printed_dirs.txt', __FILE__
DIR_LIST = Precol::DirsOnDisk.new open(db_file).readlines.map &:strip

tmpfile = Tempfile.new('foo')
tmpfile.write(open(input_csv).read.encode('UTF-8', invalid: :replace))
tmpfile.rewind
# last_index
output_csv = "#{input_csv.chomp('.csv')}-mod.csv"
CSV.open output_csv, 'wb' do |out_csv|
  # out_headers = [ 'STATUS '] + headers + ['FOUND PATH']
  out_csv << headers

  CSV.foreach tmpfile, headers: true do |row|
    # BibID Collection  Directory File Path   Link to Print at Penn     File name
    data = Precol::BookData.new row.to_hash
    if blank?(data.file_name)
      row['STATUS'] = 'NO FILE NAME'
      out_csv << row
      next
    end

    if ! blank?(data.found_path)
      if DIR_LIST.on_disk? data.path_array
        row['STATUS'] = 'MATCH' if data.path_count == 1
        row['STATUS'] = 'MULTI-MATCH' if data.path_count > 1
        out_csv << row
        next
      else
        row['STATUS'] = 'BAD FOUND PATH'
        puts sprintf("%-15s  %-30s --- %s", "BAD FOUND PATH", data.file_name, matches.inspect)
        out_csv << row
        next
      end
    end

    matches = DIR_LIST.matches data
    row['FOUND PATH'] = matches.join ' | '
    if matches.empty?
      row['STATUS'] = 'NO MATCH'
      out_csv << row
      puts sprintf("%-15s  %-30s", "NO MATCH", data.file_name)
    elsif matches.size > 1
      row['STATUS'] = 'MULTI-MATCH'
      out_csv << row
      puts sprintf("%-15s  %-30s --- %s", "MULTI-MATCH", data.file_name, matches.inspect)
    else
      row['STATUS'] = 'MATCH'
      out_csv << row
      puts sprintf("%-15s  %-30s --- %s", "MATCH", data.file_name, matches.first)
    end
  end
end

STDERR.puts "Wrote #{output_csv}"
