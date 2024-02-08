defmodule KQWeb.Router do
  use KQWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {KQWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KQWeb do
    pipe_through :browser

    live_session :auth_check, on_mount: KQWeb.InitAssigns do
      live "/", IndexLive
      live "/quiz/:id", QuizLive, :show
      live "/quiz/:id/outcome/:number", OutcomeLive, :show
      live "/trivia/:id", TriviaQuizLive, :show
    end

    get "/login", AuthController, :login
  end
end
