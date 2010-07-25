class Notifications < ActionMailer::Base
  default :from => "admin@problemchildmag.com"
  default_url_options[:host] = "pcmag.heroku.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.actionmailer.notifications.new_composition.subject
  #
  def new_composition(composition)
    @title = composition.title
    @composition_body = composition.body
    @author = composition.author
    @url = composition_url(composition)

    mail(:to => "admin@problemchildmag.com",
      :subject => "Submission: \"#{@title}\" by #{@author}"
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.actionmailer.notifications.signup.subject
  #
  def signup
    @greeting = "Hi"

    mail :to => "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.actionmailer.notifications.forgot_password.subject
  #
  def forgot_password
    @greeting = "Hi"

    mail :to => "to@example.org"
  end
end
