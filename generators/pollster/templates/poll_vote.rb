class <%= class_name %>Vote < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :<%= object_name %>

end