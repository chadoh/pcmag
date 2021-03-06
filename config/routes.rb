Pc::Application.routes.draw do

  get "" => "publications#new", constraints: { subdomain: 'secret-sign-up' }

  constraints subdomain: /.+/ do
    resources :publications, except: [:index, :new, :show]

    as :person do
      put "/person/confirmation" => "confirmations#update", as: :update_user_confirmation
    end

    devise_controller_overrides = {
      sessions: "people/sessions",
      registrations: "people/registrations",
      confirmations: "confirmations"
    }
    devise_for :people, controllers: devise_controller_overrides do
      get "sign_in", to: "people/sessions#new", as: "sign_in"
      get "sign_up", to: "people/registrations#new"
    end

    resources :people, except: [:index, :new] do
      member do
        post "contact"
        post "toggle_default_tips", as: "toggle_default_tips_for"
      end
      collection { get "autocomplete" }
    end

    resources :roles, only: [:new, :create, :destroy]
    resources :scores, only: [:create, :update, :destroy]
    resources :positions, :editors_notes, except: :index
    resources :cover_arts, :table_of_contents, :staff_lists, only: [:create, :destroy]

    resources :meetings do
      resources :attendees, only: [:create, :edit, :update, :destroy] do
        member { put "update_answer" => :update_answer, :as => "update_answer_for" }
      end
      member { get  "scores" => :scores, :as => "scores_for" }
    end

    resources :packlets, only: [:create, :destroy] do
      member { put "update_position" }
    end

    resources :issues do
      member do
        get "highest_scores", as: "highest_scored_for"
        get "staff_list", as: "staff_for"
        post :publish
        post :notify_authors_of_published_issue, as: "notify_authors_of_published"
      end
    end
    resources :issues, only: [] do
      resources :pages, path: "pages", only: [:create]
      resources :pages, path: "", only: [:show, :update, :destroy] do
        member do
          put :add_submission
        end
      end
    end

    get "submit" => "submissions#new", as: "new_submission"
    resources :submissions, path: "submissions", only: [:index, :create]
    resources :submissions, path: "", except: [:index, :create], path_names: { :new => "/submit" }


    get "" => "publications#show"
  end # subdomain

  root to: "publications#show"
end
