class Version < ActiveRecord::Base

  def object
    YAML.load(self.content)
  end

end
