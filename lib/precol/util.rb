module Precol
  module Util
    def Util.blank? val
      return true if val.nil?
      return true if val.respond_to?(:empty?) && val.empty?
      val.kind_of?(String) and val.strip.empty?
    end

    def Util.valid_bibid? bibid
      bibid.to_s =~ /\A\d+\z/
    end

    def Util.old_bibid? bibid
      valid_bibid?(bibid) && !new_bibid?(bibid)
    end

    def Util.new_bibid? bibid
      bibid.to_s =~ /\A99\d{4,}3503681\z/
    end

    ##
    # Return bibid if bibid is of new type; otherwise, convert to new version.
    def Util.new_bibid bibid
      return bibid if new_bibid? bibid

      "99#{bibid}3503681"
    end

  end
end