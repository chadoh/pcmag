require 'spec_helper'

describe "Publications" do
  describe "GET \#{publication.subdomain}.publishist.com" do
    it "loads up a random published submission from the publication and info about the publication" do
      publication = Factory.create(:publication)
      magazine = Factory.create(:magazine, publication: publication, published_on: Date.yesterday, notification_sent: true)
      submission = Factory.create(:submission, publication: publication, magazine: magazine, state: :published)

      visit root_url(subdomain: publication.subdomain)
      expect(page).to have_content(submission.title)
      expect(page).to have_content(publication.about)
    end
  end
  describe "GET \#{some unrecognized subdomain}.publishist.com" do
    it "renders 404" do
      expect { visit root_url(subdomain: "nonsense") }.to raise_error(ActionController::RoutingError)
    end
  end
  describe "POST some-subdomain.publishist.com" do
    it "creates a publication and an editor for that publication" do
      post "http://whatever.publishist.com/publications", publication_name: "Fancy Prance", editor_email: "hello@there.you"
      expect(Publcation.count).to eq 1
      expect(Person.count).to eq 1
      expect(response.path).to eq "/"
      expect(response.body).to match "hello@there.you"
    end
  end
end
