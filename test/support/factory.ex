defmodule Quiz.Factory do
  # use with Ecto
  use ExMachina.Ecto, repo: Quiz.Repo

  alias Quiz.Quizzes.Quiz

  def quiz_factory do
    %Quiz{
      title: "What kind of pizza are you?"
    }
  end
end
