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

    live "/", TitleLive
    live "/quiz", QuizLive
    live "/outcome/:id", OutcomeLive, :show
  end
end
