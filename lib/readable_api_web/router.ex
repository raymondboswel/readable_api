defmodule ReadableApiWeb.Router do
  use ReadableApiWeb, :router

  import ReadableApiWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :no_layout do
    plug :put_layout, false
  end

  scope "/api/v1", ReadableApiWeb.API.V1, as: :api_v1_open do
    pipe_through :api
    post "/user/authenticate", UserSessionController, :create
    post "/user/renew", UserSessionController, :renew
    post "/user/register", UserRegistrationController, :create
    delete "/user/log_out", UserSessionController, :delete
  end

  scope "/api/v1", ReadableApiWeb.API.V1, as: :api_v1 do
    pipe_through [
      :api,
      :fetch_current_user,
      :require_authenticated_user,
      :put_secure_browser_headers
    ]

    put "/user/settings", UserSettingsController, :update
    resources "/books", BookController, except: [:new, :edit]
    resources "/clubs", ClubController, except: [:new, :edit]
    get "/clubs/:id/books", ClubController, :club_books
  end

  scope "/", ReadableApiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ReadableApiWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ReadableApiWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", ReadableApiWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", ReadableApiWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", ReadableApiWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
  end

  scope "/", ReadableApiWeb do
    pipe_through [:browser, :no_layout]
    get "/users/confirm/:token", UserConfirmationController, :confirm
    get "/users/confirm/test", UserConfirmationController, :confirm_test
  end
end
