class DocumentItem::MqtmComic < DocumentItem

  attr_accessor :mqtm_history_id
  
  def mqtm_history
    MqtmHistory.find(@mqtm_history_id)
  end

end
