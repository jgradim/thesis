class Serializable::MqtmComic < Serializable

  attr_accessor :mqtm_history_id
  
  def mqtm_history
    MqtmHistory.find(@mqtm_history_id)
  end

end
