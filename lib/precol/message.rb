module Precol
  module Messsage
    module ClassMethods

    end

    module InstanceMethods

      def verbose?
        !!@verbose
      end

      def message &block
        return unless verbose?
        yield
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end