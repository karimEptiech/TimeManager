defmodule ProjectWeb.Router do
  alias Mix.Project
  use ProjectWeb, :router

  pipeline :browser do
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ProjectWeb.LayoutView, :root}
    plug :put_secure_browser_headers
    plug CORSPlug, origin: ["*"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ProjectWeb.Plugs.AuthPlug
  end

  pipeline :admin do
    plug ProjectWeb.Plugs.EnsureRole, ["admin"]
  end

  pipeline :manager do
    plug ProjectWeb.Plugs.EnsureRole, ["manager"]
  end

  pipeline :user do
    plug ProjectWeb.Plugs.EnsureRole, ["user"]
  end

  scope "/auth", ProjectWeb do
    pipe_through :browser

    post "/login", AuthController, :login
    post "/register", AuthController, :register
  end
  scope "/admin", ProjectWeb do
    pipe_through [:browser, :auth, :admin]
    get "/users/all", AdminController, :get_all
    get "/users", AdminController, :get_by_email_and_username
    get "/users/:userID", AdminController, :get
    put "/users/:userID", AdminController, :update
    delete "/users/:userID", AdminController, :delete
    get "/workingtimes", AdminController, :get_workingtimes_from_to
    get "/workingtimes/:userID", AdminController, :get_workingtimes_from_to_by_user_id
    get "/workingtimes/:userID/:id", AdminController, :get_workingtime_by_user_id_and_id
    post "/workingtimes/:userID", AdminController, :create_workingtime
    put "/workingtimes/:id", AdminController, :update_workingtime
    delete "/workingtimes/:id", AdminController, :delete_workingtime_by_id
    get "/clocks/:userID", AdminController, :get_clocks_by_user_id
    post "/clocks/:userID", AdminController, :clock_in
  end
  scope "/manager", ProjectWeb do
    pipe_through [:browser, :auth, :manager]
    get "/users/all", ManagerController, :get_all
    get "/users", ManagerController, :get_by_email_and_username
    get "/users/:userID", ManagerController, :get
    put "/users/:userID", ManagerController, :update
    get "/workingtimes", ManagerController, :get_workingtimes_from_to
    get "/workingtimes/:userID", ManagerController, :get_workingtimes_from_to_by_user_id
    get "/workingtimes/:userID/:id", ManagerController, :get_workingtime_by_user_id_and_id
    post "/workingtimes/:userID", ManagerController, :create_workingtime
    put "/workingtimes/:id", ManagerController, :update_workingtime
    delete "/workingtimes/:id", ManagerController, :delete_workingtime_by_id
    get "/clocks/:userID", ManagerController, :get_clocks_by_user_id
    post "/clocks/:userID", ManagerController, :clock_in
  end


  scope "/user", ProjectWeb do
    pipe_through [:browser, :auth, :user]
    post "/clocks/", UserController, :clock_in
    get "/clocks/", UserController, :get_clocks_by_user_id
    get "/workingtimes", UserController, :get_workingtimes_from_to_by_user_id
    put "/", UserController, :update
    delete "/", UserController, :delete
  end
  # Other scopes may use custom stacks.
  # scope "/api", ProjectWeb do
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

      live_dashboard "/dashboard", metrics: ProjectWeb.Telemetry
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
end
