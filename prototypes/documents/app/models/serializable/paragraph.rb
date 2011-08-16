class Serializable::Paragraph < Serializable

  attr_accessor :content, :title

  defaults :title,   Proc.new{ I18n.t('globals.untitled') } # "Sem título"
  defaults :content, ""

end
