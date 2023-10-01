defmodule Quiz.Repo do
  use Ecto.Repo,
    otp_app: :quiz,
    adapter: Ecto.Adapters.SQLite3
end
