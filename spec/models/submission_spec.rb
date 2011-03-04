require 'spec_helper'

describe Submission do
  before(:each) do
    @person = Factory.create :person
  end

  it {
    should have_many(:packlets).dependent(:destroy)
    should have_many(:meetings).through(:packlets)
    should have_many(:scores).through(:packlets)
    should belong_to(:author)
  }

  it "sets queued submissions to reviewed if their meeting is less than three hours in the future" do
    meeting = Factory.create :meeting
    submission = Factory.create :submission
    meeting.submissions << submission
    meeting.update_attribute :datetime, 2.hours.from_now
    submission.reload.should be_reviewed
    submission.update_attribute :state, Submission.state(:queued)
    submission.should be_queued
    submission.reload.should be_reviewed
  end

  describe "#has_been" do
    it "moves the sumbission into the specified state" do
      sub = Factory.build :submission
      sub.has_been :reviewed
      sub.state.should == :reviewed
    end
  end

  context "has methods to check if in a certain state:" do
    before :each do
      @sub = Submission.create :title => "Cheese",
                               :body => "Whiz",
                               :author => Factory.create(:person)
    end

    it "has a #draft? method" do
      (@sub.draft?).should be_true
    end

    it "has a #submitted? method" do
      (@sub.submitted?).should be_false
    end
  end

  it "sets the author_name field to 'anonymous' if there is no associated author" do
    sub = Submission.create :title => "some ugly cat", :author_email => "non@one.me"
    sub.author_name.should == "Anonymous"
  end

  it "verifies that there is either an associated author or an author_email" do
    sub = Submission.new :title => "Marvin eats an ice cream cone"
    sub.should_not be_valid

    sub.author_email = "marvin@gmail.mars"
    sub.should be_valid

    sub.author_email = nil
    sub.author = Factory.create :person
    sub.should be_valid
  end

  it "verifies that there is either a title or a body" do
    sub = Submission.new :author_email => "samwell@gamgee.net"
    sub.should_not be_valid

    sub.title = "Who, me?"
    sub.should be_valid

    sub.title = nil
    sub.body = "But of course!"
    sub.should be_valid
  end

  describe "#author_name" do
    it "returns the author_name field if there is no associated author" do
      @sub = Submission.create(
        :title => ';-)',
        :body => 'he winks and smiles <br><br> both',
        :author_email => 'me@you.com',
        :author_name => "Smeagul Rabbit"
      )
      @sub.author_name.should == "Smeagul Rabbit"
    end

    it "returns the associated author's name if there is an associated author" do
      @sub = Submission.create(
        :title  => ';-)',
        :body   => 'he winks and smiles <br><br> both',
        :author => @person
      )
      @sub.author_name.should == @person.name
    end
  end

  describe "#average_score" do
    before do
      @submission = Factory.create :submission
      @meeting = Factory.create :meeting
      2.times { @meeting.people << Factory.create(:person) }
      @packlet = @meeting.packlets.create :submission => @submission
      @packlet.scores.create :attendee => @meeting.attendees.first, :amount => 4
      @packlet.scores.create :attendee => @meeting.attendees.last , :amount => 6
    end

    it "returns the average score for the submission" do
      @submission.average_score.should == 5
    end
  end

  describe "#magazine" do
    it "returns the submission's magazine, as told by its first meeting" do
      mag = Factory.create :magazine
      meeting = Factory.create :meeting
      meeting.update_attributes :magazine => mag
      sub = Factory.create :submission
      meeting.submissions << sub
      sub.magazine.should == mag
    end
  end
end
