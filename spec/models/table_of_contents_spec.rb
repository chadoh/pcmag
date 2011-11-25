require 'spec_helper'

describe TableOfContents do
  before :each do
    @magazine = Magazine.create(
      :accepts_submissions_from  => 6.months.ago,
      :accepts_submissions_until => 1.week.ago,
      :nickname                  => "Fruit Blots"
    )
    @submission  = Factory.create :submission, pseudonym_name: "Karis", pseudonym_link: false
    @submission2 = Factory.create :submission
    @meeting     = Meeting.create(datetime: 2.weeks.ago, question: "orly?")
    @meeting.submissions << [@submission, @submission2]
    @magazine.publish [@submission, @submission2]
    @page = @magazine.pages.first
    @table_of_contents = @page.table_of_contents = TableOfContents.new(page: @page)
  end

  it {
    should belong_to :page
    should have_one(:magazine).through(:page)
  }

  describe "#hash" do
    it "constructs a hash with each submission & its page" do
      hash = @table_of_contents.hash
      hash[@submission].should == { page: @submission.page }
      hash[@submission2].should == { page: @submission2.page }
    end
  end

end
