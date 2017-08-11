#!/usr/bin/env ruby

$:.unshift File.expand_path '../../lib', __FILE__
require 'precol'
require 'precol/util'
require 'csv'
require 'optparse'
require 'tempfile'

################################################################################
# add_multi.rb
#
# Add MM_Metadata.xlsx and sha1_ready.txt files to each 'FOUND PATH' in in
# BIBID_DIR_CSV, using associated BibID.
#
# Expect sheet to have column headings 'FOUND PATH' and 'BIBID' (case
# sensitive). The headers can be changed by setting shell/environment
# variables PRECOL_DIRECTORY_HEADER and PRECOL_BIBID_HEADER.
#
################################################################################

def usage
  "Usage: #{File.basename __FILE__} BIBID_DIR_CSV"
end

def exit_with_error parser, msg
  puts "ERROR: #{msg}"
  puts parser.banner
  exit 1
end

def print_error msg
  STDERR.puts "ERROR: #{msg}"
end

BIBID_HEADER     = ENV['PRECOL_BIBID_HEADER']     || 'BibID'
DIRECTORY_HEADER = ENV['PRECOL_DIRECTORY_HEADER'] || 'FOUND PATH'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename __FILE__} [options] BIBID_DIR_CSV"

  opts.on "-q", "--[no-]quiet", "Be silent" do |q|
    options[:quiet] = q
  end

  opts.on "-x", "--[no-]clobber", "Overwrite existing files [default=false]" do |x|
    options[:clobber] = x
  end

  opts.on "-p", "--prefix PATH", "Prefix path for directories [default=.]" do |prefix|
    options[:prefix] = prefix
  end

  opts.on "-w", "--no-warn", "Don't print warnings" do |w|
    options[:no_warn] = true
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    puts <<EOF

Add MM_Metadata.xlsx and sha1_ready.txt files to each 'FOUND PATH' in in
BIBID_DIR_CSV, using associated BibID.

Expect sheet to have column headings 'FOUND PATH' and 'BIBID' (case
sensitive). The headers can be changed by setting shell/environment
variables PRECOL_DIRECTORY_HEADER and PRECOL_BIBID_HEADER.
EOF
    exit
  end
end

parser.parse!

output_file = options[:output_file] || 'output.csv'
prefix      = options[:prefix] || '.'

input_csv = ARGV.shift
exit_with_error parser, "Not a valid CSV" unless File.file? input_csv

# The input file may have bad encoding in it. Strip those characters out.
# Hopefully, this won't alter any paths.
tmpfile = Tempfile.new('foo')
tmpfile.write(open(input_csv).read.encode('UTF-8', invalid: :replace))
tmpfile.rewind

CSV.foreach tmpfile, headers: true do |row|
  dest_dir = File.join prefix, row[DIRECTORY_HEADER]
  bibid    = row[BIBID_HEADER]

  unless File.directory? dest_dir
    print_error "Not a valid directory #{dest_dir}"
    next
  end

  init_opts = { quiet: options[:quiet], clobber: options[:clobber] }
  dir = Precol::Directory.new dest_dir, bibid, init_opts
  dir.prep and next
  STDERR.puts "WARNING: Directory not prepped #{dest_dir}" unless options[:no_warn]

end