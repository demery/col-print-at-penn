module Precol
  module Clobberable
    module ClassMethods

    end

    module InstanceMethods
      def clobber?
        !!@clobber
      end
    end

    def self.included(receiver)
      attr_accessor :clobber
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end