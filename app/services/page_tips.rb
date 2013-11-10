class PageTips
  def initialize(page, person, include_conditional_tips)
    @page = page
    @person = person
    @include_conditional_tips = include_conditional_tips
  end

  def tips
    return nil unless @person && @person.orchestrates?

    tips = case @page
    when "publications#show"
      { "This page features one of your published works, randomly selected on each page load." => "key",
        "This is your home page. You can edit the content on it with the pencil link at the bottom." => "info",
      }
    when "magazines#index"
      { "It looks like an issue's submission period is over! You can review it's highest scored submissions and then publish it so everyone in the world can come read it." => "key",
        "Click 'Staff List' for any issue to fine-tune who can view submissions' authors, scores, and meetings for that issue." => "info",
      }
    when "magazines#highest_scores"
      { "These are the highest-scored submissions for this issue. You can uncheck some, if you don't want them published." => "info",
      }
    when "pages#show"
      { "This will not be publicly browsable until you click \"Let everyone who submitted know it's been published\"." => "key",
        "Use the inline controls in the pagination to add & remove pages." => "info",
        "You can click the right edge of a submission and drag to a new page (note: it will drop onto the page with the dotted outline, not necessarily the one you're moused over. :-/ )" => "info",
        "Click the big plus at the bottom left to add notes or special items to pages." => "info",
      }
    when "magazines#staff_list"
      { "This is your main command center. All of the permissions for the whole website are based on what's on these staff lists; controlled issue-by-issue." => "info",
        "Mouse over the little circular letters next to the name of each position to see what abilities people in that position have." => "info",
        "You don't have to name your positions this way. Each issue can have uniquely-named positions, and different permission structures. Use the pencil icons to change it up." => "info",
        "To keep everything from breaking, if someone has the \"orchestrates\" ability for an issue, they'll be able to edit the staff lists of adjacent issues." => "info"
      }
    when "meetings#index"
      { "Publishist encourages you to have regularly-scheduled, real-life meetings of your staff where you read submissions aloud, discuss, and score them." => "info",
        "You don't have to do that, but be aware that scores can only be entered from a meeting's page, so you'll have to at least pretend you have coordinated meetings." => "info",
        "Each meeting has a \"Question\". Answering a creative question makes roll call way more fun." => "info",
      }
    when "meetings#show"
      { "This is where you'll probably spend most of your time, if you have regular staff meetings." => "info",
        "Attendees listed at the bottom can enter their own scores for the submissions at the top. (Bring laptops to the meeting & do it there!)" => "info",
        "If attendees don't enter their own scores, then someone with the \"scores\" ability can for them (control permissions on the staff list page, accessed from the magazines list)." => "info",
        "Each attendee can also edit their own answer to the attendance question by mousing over & clicking their current answer." => "info",
      }
    when "submissions#index"
      { "Think of this as your Publishist inbox. When people submit, the submissions show up here." => "info",
        "Schedule submissions for meetings by dragging and dropping them." => "info",
        "You can reorder submissions within a meeting by clicking through to the meeting's page (the orange dates are the links you want)." => "info",
        "If you want to re-review a submission at multiple meetings, drag it from the old meeting to the new one." => "info",
        "See a list of all the submissions for some other issue by clicking that issue in the sidebar." => "info",
      }
    when "submissions#new"
      { "Most people will be see \"Submit\" in the nav bar instead of \"Submissions\", so it will be easy for them to get here. You see \"Submissions\" because you have the \"orchestrates\" ability (see a magazine's staff list page to learn about abilities)." => "info",
        "Anonymous, not-signed-in visitors can submit and will be signed up in the process." => "info",
        "You can backfill old issues by submitting here as usual, but select the older issue from the list at the bottom." => "info",
        "As you can see at the bottom, you can submit for anyone. This is because you have the \"communicates\" ability for an issue. (Again, visit a staff list to learn about abilities.)" => "key",
      }
    when "people#show"
      { "On your own page, you can keep track of everything you've submitted. You can see what's been scheduled for review, what's been scored & how it's been scored, works that made it & works that didn't." => "info",
        "All other visitors to your page will see only your published works." => "info",
        "We at Publishist think that the list of positions you accrue in the sidebar looks great on a resumé. ;-)" => "info",
      }
    end
    tips = remove_conditional(tips) unless @include_conditional_tips
    tips
  end

  private

  def remove_conditional(tips)
    tips and tips.reject { |key, value| value == "key" }
  end
end