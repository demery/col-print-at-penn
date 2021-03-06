require 'precol/message'

module Precol
  module Clobberable
    include Precol::Messsage

    module ClassMethods

    end

    module InstanceMethods
      def clobber?
        !!@clobber
      end

      ##
      # Test if file can be written based on file non-existance or `clobber?`;
      # returns true if file does not exist or can be overwritten. Prints
      # appropriate message if file exists.
      #
      def write_prep outfile
        return true unless File.exists? outfile

        # OK, file exists. See if we can clobber it
        if clobber?
          message { sprintf "Overwriting existing file '%s'", outfile }
          return true
        end

        message { sprintf "Not overwriting existing file '%s'", outfile }
        false
      end

    end

    def self.included(receiver)
      attr_accessor :clobber
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end