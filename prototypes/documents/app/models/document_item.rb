class DocumentItem

  def initialize(params)
    params.each do |k,v|
      self.send("#{k}=", v)
    end
  end
  
end
