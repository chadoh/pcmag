# == Schema Information
# Schema version: 20110516234654
#
# Table name: meetings
#
#  id          :integer         not null, primary key
#  datetime    :datetime
#  question    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  issue_id :integer
#

class Meeting < ActiveRecord::Base
  belongs_to :issue

  has_many :attendees, :dependent => :destroy
  has_many :people, :through => :attendees
  has_many :packlets, :dependent => :destroy, :order => 'position', :include => :submission
  has_many :submissions, :through => :packlets

  default_scope order("datetime ASC")

  after_save :submissions_have_been_reviewed_or_queued

  validates_presence_of :datetime

protected

  def submissions_have_been_reviewed_or_queued
    if datetime < Time.now + 3.hours
      self.submissions.each do |s|
        s.has_been :reviewed if s.queued?
      end
    else
      self.submissions.each do |s|
        s.has_been :queued if s.reviewed?
      end
    end
  end
end
