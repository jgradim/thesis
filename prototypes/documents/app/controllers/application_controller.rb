# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # Creates a reference to all classes inside app/models/ in order to marshal/unmarshal
  # http://railsagainstignorance.wordpress.com/2007/05/01/rails-find-include-rubys-marshal-and-argumenterror-undefined-classmodule/
  Dir.glob("#{RAILS_ROOT}/app/models/**/*.rb").map{ |m| m.match(/app\/models\/(.*)$/)[1] }.each do |m|
    m.match(/(.*)\..*/)[1].split("/").map(&:classify).join('::').constantize.class
  end
end
