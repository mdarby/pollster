# == Schema Information
# Schema version: 20090109155322
#
# Table name: polls
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  description   :text
#  options       :text
#  ends_at       :date
#  created_at    :datetime
#  updated_at    :datetime
#  created_by_id :integer(4)
#

class Poll < ActiveRecord::Base
  
  serialize :options
  
  has_many :votes, :class_name => 'PollVote', :dependent => :destroy
  has_many :voters, :through => :votes, :source => :user
  belongs_to :author, :foreign_key => 'created_by_id', :class_name => 'User'
  
  validates_presence_of :ends_at, :name, :created_by_id
  
  
  def is_updatable_by(user)
    user == author && !has_votes?
  end

  def is_deletable_by(user)
    user == author && !has_votes?
  end

  def self.is_readable_by(user, object = nil)
    user.is_employee?
  end

  def self.is_creatable_by(user)
    user.is_leader_or_better?
  end
  
  def can_by_voted_on_by(user)
    active? && !has_already_voted?(user)
  end
  
  def has_already_voted?(user)
    voters.include?(user)
  end
  
  def active?
    Time.now < ends_at.end_of_day
  end
    
  def visible?
    Date.today < (ends_at + 7.days)
  end
  
  def winner
    return nil if active?
    
    index = current_results_percentages.index(winning_percentage)
    options[index]
  end
  
  def winners
    return nil if active? || !ends_in_tie?
    
    winners = []
    percentage = winning_percentage
    
    current_results_percentages.each_with_index do |p, index|
      winners << options[index] if p == winning_percentage
    end
    
    winners
  end
  
  def ends_in_tie?
    percentage = winning_percentage
    current_results_percentages.select{|p| p == percentage}.size > 1
  end
  
  def winning_percentage
    current_results_percentages.sort.reverse.first
  end
  
  def self.visible
    all.select{|p| p.visible?}
  end
  
  def current_results_percentages
    options.inject([]) do |memo, option|
      num_votes = num_votes_for(option)
      memo << percentage_of_votes_for(option)
    end
  end
  
  def num_votes_for(option)
    return 0 unless has_votes?
    votes.select{|v| v.vote == option}.size
  end
  
  def pie_legend
    legend = []

    options.each_with_index do |option, index|
      legend << "%23#{index + 1} (#{formatted_percentage_of_votes_for(option)})"
    end
    
    legend
  end
  
  def total_votes
    votes.size.to_f
  end
  
  def percentage_of_votes_for(option)
    return 0.0 unless has_votes?
    num_votes_for(option) / total_votes
  end
  
  def formatted_percentage_of_votes_for(option)
    "#{sprintf("%0.0f", percentage_of_votes_for(option) * 100)}%"
  end
  
  def has_votes?
    total_votes > 0
  end
  
  def options=(arr)
    write_attribute(:options, [*arr].map{|x| x["options"]})
  end
  
end