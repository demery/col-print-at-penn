#!/usr/bin/env ruby

$:.unshift File.expand_path '../../lib', __FILE__
require 'precol'
require 'precol/util'
require 'csv'

################################################################################
# add_multi.rb
#
# Add MM_Metadata.xlsx and sha1_ready.txt files to each DIRECTORY in in
# BIBID_DIR_CSV, using associated BIBID.
#
# Expect sheet to have column headings 'DIRECTORY' and 'BIBID' (case
# sensitive).
#
################################################################################

def usage
  "Usage: #{File.basename __FILE__} BIBID_DIR_CSV"
end

def exit_with_error msg
  puts "ERROR: #{msg}"
  puts usage
  exit 1
end

def print_error msg
  STDERR.puts "ERROR: #{msg}"
end

input_csv = ARGV.shift

exit_with_error "Not a valid CSV" unless File.file? input_csv

CSV.foreach input_csv, headers: true do |row|
  dest_dir = row['DIRECTORY']
  bibid    = row['BIBID']

  unless File.directory? dest_dir
    print_error "Not a valid directory #{directory}"
    next
  end

  dir = Precol::Directory.new dest_dir, bibid, verbose=true
  dir.prep

end