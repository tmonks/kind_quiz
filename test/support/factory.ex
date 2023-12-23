defmodule KQ.Factory do
  # use with Ecto
  use ExMachina.Ecto, repo: KQ.Repo

  alias KQ.Quizzes.Answer
  alias KQ.Quizzes.Outcome
  alias KQ.Quizzes.Question
  alias KQ.Quizzes.Quiz

  def quiz_factory do
    %Quiz{
      title: "What kind of pizza are you?",
      type: :category,
      is_active: true
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
      number: sequence(:outcome_number, & &1, start_at: 1)
    }
  end
end
