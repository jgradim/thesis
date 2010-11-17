# Creates a reference to all classes inside app/models/ in order to marshal/unmarshal
# http://railsagainstignorance.wordpress.com/2007/05/01/rails-find-include-rubys-marshal-and-argumenterror-undefined-classmodule/
def load_serializable_classes
  Dir.glob("#{RAILS_ROOT}/app/models/**/*.rb").map{ |m| m.match(/app\/models\/(.*)$/)[1] }.each do |m|
    m.match(/(.*)\..*/)[1].split("/").map(&:classify).join('::').constantize.class
  end
end
load_serializable_classes

