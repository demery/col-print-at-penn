module Precol
  module Messsage
    module ClassMethods

    end

    module InstanceMethods

      def quiet?
        !!@quiet
      end

      def message &block
        return if quiet?
        puts yield
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end