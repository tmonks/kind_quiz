defmodule KindQuiz.Questions do
  @moduledoc """
  Loads quiz and questions data
  """

  alias KindQuiz.Repo
  alias KindQuiz.Quizzes.Outcome
  alias KindQuiz.Quizzes.Quiz

  @title "What kind of superhero are you?"

  @outcomes ["Captain America", "Black Panther", "Iron Man", "Hawkeye", "Thor"]

  @questions_csv """
  text,response_1,response_2,response_3,response_4,response_5
  What is your favorite subject in school?,History,Science,Technology,Physical Education,Mythology
  How do you like to spend your free time?,Helping others,Studying or reading,Inventing or building things,Practicing archery or other sports,Exploring the outdoors
  What is your dream job?,Soldier or Police Officer,Leader or Diplomat,Engineer or Inventor,Professional Athlete,Explorer or Adventurer
  What is your favorite animal?,Eagle,Panther,Robot (Yes it counts!),Hawk,Dragon
  How do you handle conflict?,Stand my ground and fight for what's right,Use wisdom and diplomacy,Outsmart the opponent,Keep a cool head and aim true,Charge in with all my might
  """

  @doc """
  Returns a quiz by id. Raises an error if the id is invalid.
  """
  def get_quiz!(id) do
    Repo.get!(Quiz, id)
    |> Repo.preload(questions: :answers)
  end

  @doc """
  Returns a list of all quizzes.
  """
  def list_quizzes do
    Repo.all(Quiz)
  end

  @doc """
  Returns an array of questions and answers.
  """
  def get_questions do
    CSV.decode!([@questions_csv], headers: true, field_transform: &String.trim/1)
    |> Enum.to_list()
    |> Enum.map(&row_to_question/1)
  end

  defp row_to_question(row) do
    {text, row} = Map.pop(row, "text")
    %{text: text, answers: Map.values(row)}
  end

  @doc """
  Returns the title of the quiz
  """
  def get_title, do: @title

  @doc """
  Returns the list of possible outcomes
  """
  def list_outcomes, do: @outcomes

  @doc """
  Returns the outcome with the given id. Raises an error if the id is invalid.
  """
  def get_outcome!(id) do
    Repo.get!(Outcome, id)
  end
end
