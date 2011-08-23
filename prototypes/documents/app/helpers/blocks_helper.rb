module BlocksHelper

  def block_params_type(serializable)
    hidden_field_tag 'block[type]', serializable.class.to_s.tableize
  end

  def block_partial(serializable)
    render :partial => "#{serializable.class.to_s.tableize}/form", :object => serializable
  end

end
