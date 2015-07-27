class Integration < ActiveRecord::Base
  MAILERLITE_SERVICE = 1


  validates_presence_of :api_key, :service, :list_id

end
