# == Schema Information
# Schema version: 20090108210616
#
# Table name: poll_votes
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  vote       :string(255)
#  poll_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class PollVote < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :poll

end