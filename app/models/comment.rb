class Comment < ActiveRecord::Base
  attr_accessible :body
  validates :body, :length => { :minimum => 0 }, :presence => true
end
