Given /^there is a magazine$/ do
  Magazine.create
end

Given /^a magazine's timeframe is \*nearly\* over$/ do
  Magazine.create(
    :accepts_submissions_from => 6.months.ago,
    :accepts_submissions_until => Date.tomorrow
  )
end

Given /^a magazine's timeframe is freshly over$/ do
  Magazine.create(
    :accepts_submissions_from => 6.months.ago,
    :accepts_submissions_until => Date.yesterday
  )
end

Given /^10 meetings have occured in it$/ do
  mag = Magazine.first
  10.times { mag.meetings << Factory.create(:meeting) }
end

Given /^(\d)+ submissions have been reviewed at these meetings$/ do |total_submissions|
  for meeting in Magazine.first.meetings
    (total_submissions.to_i/10).times { meeting.submissions << Factory.create(:submission) }
  end
end

Given /^10 people have attended each of these meetings$/ do
  # the viewer (the editor) already counts as 1
  9.times { Factory.create(:person) }
  for meeting in Magazine.first.meetings
    for person in Person.all
      Attendee.create :meeting => meeting, :person => person
    end
  end
end

Given /^submissions at meeting 1 have all been scored 1, scored 2 at meeting 2, etc$/ do
  Magazine.first.meetings.each_with_index do |meeting, i|
    for packlet in meeting.packlets
      for attendee in meeting.attendees
        Score.create :packlet => packlet, :attendee => attendee, :amount => i
      end
    end
  end
end

Then /^I should see "([^"]*)" in the "([^"]*)" field$/ do |text, field|
  page.has_field? field, :with => text
end

Then /^I should see all the submissions$/ do
  count = Submission.count
  count.should == page.find("body").text.split("Submission").length - 1
end

Then /^I should see half the submissions$/ do
  count = Submission.count / 2
  count.should == page.find("body").text.split("Submission").length - 1
end
