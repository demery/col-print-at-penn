#!/usr/bin/env ruby

$:.unshift File.expand_path '../../lib', __FILE__
require 'precol'
require 'precol/util'
require 'optparse'

################################################################################
# add_sheet.rb
#
# Add MM_Metadata.xlsx and sha1_ready.txt files to DEST_DIR, using given
# OLD_BIBID.
#
# Script assumes old_bibid and converts to new format. Will break if given an
# new bibid
#
################################################################################


def usage
  "Usage: #{File.basename __FILE__} DEST_DIR OLD_BIBID"
end

def exit_with_error parser, msg
  puts "ERROR: #{msg}"
  puts parser.banner
  exit 1
end

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename __FILE__} [options] DEST_DIR OLD_BIBID"

  opts.on "-q", "--quiet", "Print no messages" do |q|
    options[:quiet] = q
  end

  opts.on "-x", "--[no-]clobber", "Overwrite existing files [default=false]" do |x|
    options[:clobber] = x
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    puts <<EOF

Add MM_Metadata.xlsx and sha1_ready.txt files to DEST_DIR, using given
OLD_BIBID.

Script assumes old_bibid and converts to new format. Will break if given a
new BibID.
EOF
    exit
  end
end

parser.parse!

exit_with_error parser, "Wrong number of arguments" unless ARGV.size == 2

dest_dir = ARGV.shift
old_bibid = ARGV.shift

exit_with_error parser, "Please provide a valid directory" unless File.directory? dest_dir
exit_with_error parser, "Please provide a valid BibID" unless Precol::Util.valid_bibid? old_bibid
exit_with_error parser, "Please provide an OLD-style BibID" if Precol::Util.new_bibid? old_bibid

dir = Precol::Directory.new dest_dir, old_bibid, quiet: options[:quiet], clobber: options[:clobber]
# puts dir.inspect
dir.prep or exit 1
