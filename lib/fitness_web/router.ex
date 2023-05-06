defmodule FitnessWeb.Router do
  use FitnessWeb, :router

  import FitnessWeb.UserAuth

  alias FitnessWeb.UserAuthLive

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FitnessWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FitnessWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :user, on_mount: {UserAuthLive, :user} do

      live "/exercises/new", ExerciseLive.Index, :new
      live "/exercises/:id/edit", ExerciseLive.Index, :edit
      live "/exercises/:id/show/edit", ExerciseLive.Show, :edit

      live "/activity_history", WorkoutTemplateLive.ActivityHistory, :history
      live "/workout_templates/new", WorkoutTemplateLive.Index, :new
      live "/workout_templates/:id/edit", WorkoutTemplateLive.Index, :edit
      live "/workout_templates/:id/show/workout_zone", WorkoutTemplateLive.WorkoutZone, :workout_zone
      live "/workout_templates/:id/show/edit", WorkoutTemplateLive.Show, :edit
    end
  end

  scope "/", FitnessWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/exercises", ExerciseLive.Index, :index
    live "/exercises/:id", ExerciseLive.Show, :show

    live "/workout_templates", WorkoutTemplateLive.Index, :index
    live "/workout_templates/:id", WorkoutTemplateLive.Show, :show
  end



  # Other scopes may use custom stacks.
  # scope "/api", FitnessWeb do
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

      live_dashboard "/dashboard", metrics: FitnessWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", FitnessWeb do
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

  scope "/", FitnessWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", FitnessWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
