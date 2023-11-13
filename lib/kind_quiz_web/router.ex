defmodule KindQuizWeb.Router do
  use KindQuizWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {KindQuizWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KindQuizWeb do
    pipe_through :browser

    live "/", IndexLive
    live "/quiz/:id", QuizLive, :show
    live "/quiz/:id/outcome/:number", OutcomeLive, :show
    live "/trivia/:id", TriviaQuizLive, :show
  end
end
