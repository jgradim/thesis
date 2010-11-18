class Version < ActiveRecord::Base

  def object
    HashObject.new(raw_object)
  end
  
  def raw_object
    JSON.load(content)
  end
  
  #
  class HashObject
    def initialize(h)
      @h = h
      @h.each do |k,v|
        #puts k,v
        @h[k] = HashObject.new(v) if v.is_a?(Hash)
      end
    end
    
    def method_missing(meth, *args, &block)
      return @h[meth.to_s]
    end
  end

end
