defmodule KindQuiz.Factory do
  # use with Ecto
  use ExMachina.Ecto, repo: KindQuiz.Repo

  alias KindQuiz.Quizzes.Quiz

  def quiz_factory do
    %Quiz{
      title: "What kind of pizza are you?"
    }
  end
end
