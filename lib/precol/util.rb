module Precol
  module Util
    def blank? val
      return true if val.nil?
      return true if val.respond_to?(:empty?) && val.empty?
      val.kind_of?(String) and val.strip.empty?
    end
  end
end