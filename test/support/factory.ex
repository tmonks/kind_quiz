defmodule KindQuiz.Factory do
  # use with Ecto
  use ExMachina.Ecto, repo: KindQuiz.Repo

  alias KindQuiz.Quizzes.Answer
  alias KindQuiz.Quizzes.Question
  alias KindQuiz.Quizzes.Quiz

  def quiz_factory do
    %Quiz{
      title: "What kind of pizza are you?"
    }
  end

  def question_factory do
    %Question{
      text: "What is your favorite topping?"
    }
  end

  def answer_factory do
    %Answer{
      text: "Pepperoni"
    }
  end
end
