#!/usr/bin/env ruby

$:.unshift File.expand_path '../../lib', __FILE__
require 'precol'
require 'precol/util'

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

def exit_with_error msg
  puts "ERROR: #{msg}"
  puts usage
  exit 1
end

exit_with_error "Wrong number of arguments" unless ARGV.size == 2

dest_dir = ARGV.shift
old_bibid = ARGV.shift

exit_with_error "Please provide a valid directory" unless File.directory? dest_dir
exit_with_error "Please provide a valid BibID" unless Precol::Util.valid_bibid? old_bibid
exit_with_error "Please provide an OLD-style BibID" if Precol::Util.new_bibid? old_bibid

dir = Precol::Directory.new dest_dir, old_bibid, verbose=true
dir.prep
