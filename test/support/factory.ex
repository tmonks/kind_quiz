defmodule KindQuiz.Factory do
  # use with Ecto
  use ExMachina.Ecto, repo: KindQuiz.Repo

  alias KindQuiz.Quizzes.Answer
  alias KindQuiz.Quizzes.Outcome
  alias KindQuiz.Quizzes.Question
  alias KindQuiz.Quizzes.Quiz

  def quiz_factory do
    %Quiz{
      title: "What kind of pizza are you?",
      type: :category
    }
  end

  def question_factory do
    %Question{
      text: "What is your favorite topping?"
    }
  end

  def answer_factory do
    %Answer{
      text: "Pepperoni",
      number: 1
    }
  end

  def outcome_factory do
    %Outcome{
      quiz: build(:quiz),
      text: "You are a pepperoni pizza!",
      number: 1
    }
  end
end
