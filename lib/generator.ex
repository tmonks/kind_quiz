defmodule KindQuiz.Generator do
  @moduledoc """
  Generatez quizzes and questions using OpenAI API
  """
  import AI

  alias KindQuiz.Quizzes.Quiz
  alias KindQuiz.Repo

  @doc """
  Generates a personality quiz
  """
  def generate_quiz(quiz_title) do
    ~l"""
    model: gpt-3.5-turbo
    system: You are a quiz generator that generates fun quizzes for 10-14 year old children which will attempt to categorize the taker in some way based on their responses.
    Each quiz should have 5 questions, each with 5 possible answers (1-5).
    Each of the answers corresponds to one of 5 possible outcomes (1-5).
    The most frequently selected answer number will determine the outcome.
    I will give you the title of the quiz, and you will generate the quiz in JSON.
    Respond ONLY with the JSON with no additional text.

    Here is an example of the format you should use:

    ```
    {
      "title": "What kind of superhero are you?",
      "outcomes": [
        { "number": 1, "text": "Captain America" },
        { "number": 2, "text": "Black Panther" },
        { "number": 3, "text": "Iron Man" },
        { "number": 4, "text": "Hawkeye" },
        { "number": 5, "text": "Thor" }
      ],
      "questions": [
        {
          "text": "How do you like to spend your free time?",
          "answers": [
            { "text": "Helping others", "number": 1 },
            { "text": "Studying or reading", "number": 2 },
            { "text": "Inventing or building things", "number": 3 },
            { "text": "Practicing archery or other sports", "number": 4 },
            { "text": "Exploring the outdoors", "number": 5 }
          ]
        }
      ]
    }
    ```
    user: #{quiz_title}
    """
    |> chat()
    |> IO.inspect()
    |> decode_response()
    |> create_changeset()
    |> Repo.insert()
  end

  defp decode_response({:ok, json}) do
    Jason.decode!(json)
  end

  defp create_changeset(attrs) do
    Quiz.changeset(%Quiz{}, attrs)
  end
end
