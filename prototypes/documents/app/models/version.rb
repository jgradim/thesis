class Version < ActiveRecord::Base

  class HashObject
    def initialize(hash)
      @hash = hash
    end
    
    def method_missing(meth, *args, &block)
      @hash[meth]
    end
  end

  def object
    JSON.load(self.content)
  end

end
