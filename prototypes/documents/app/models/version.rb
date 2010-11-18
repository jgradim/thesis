class Version < ActiveRecord::Base

  def object
    CallableHash.new(raw_object)
  end
  
  def raw_object
    JSON.load(content)
  end
  
  #
  class CallableHash
  
    def initialize(h)
      @h = h
      @h.each do |k,v|
        @h[k] = CallableHash.new(v) if v.is_a?(Hash)
        @h[k] = v.map { |o|
          o.is_a?(Hash) ? CallableHash.new(o) : o
        } if v.is_a?(Array)
      end
    end
    
    def method_missing(meth, *args, &block)
      return @h[meth.to_s]
    end
    
  end

end
