defmodule KindQuiz.Generator do
  @moduledoc """
  Generatez quizzes and questions using OpenAI API
  """
  import AI

  alias KindQuiz.Quizzes.Quiz
  alias KindQuiz.Repo

  @doc """
  Generates a category quiz
  """
  def generate_category_quiz(quiz_title, outcomes \\ 5) do
    outcome_text =
      if is_list(outcomes) do
        Enum.join(outcomes, ", ")
      else
        outcomes
      end

    ~l"""
    model: gpt-3.5-turbo
    system: You are a quiz generator that generates fun quizzes for 10-14 year old children.
    The quiz will attempt to categorize the taker in some way based on their responses.
    Each quiz should have 5 questions.
    Each quiz will have a certain number of possible outcomes (i.e. categories that the taker can be placed in).
    Each question should have a number of possible answers equal to the number of possible outcomes.
    The most frequently selected answer number will determine the outcome.
    Each question's answer `number` 1 will correspond to the outcome with `number` 1, and so on.
    Insert a relevant emoji at the beginning of the title.
    I will give you the title of the quiz, and either the specific outcomes or the number of outcomes for you to make up.
    Please generate the quiz in JSON format like the example below.
    Respond ONLY with the JSON with no additional text.

    User: "Title: 💪 What kind of superhero are you? Outcomes: 5"

    You:

    ```
    {
      "title": "What kind of superhero are you?",
      "type": "category",
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
      // 4 more questions...
    }
    ```
    user: Title: #{quiz_title}, Outcomes: #{outcome_text}
    """
    |> chat()
    |> decode_response()
    # |> IO.inspect()
    |> create_changeset()
    |> Repo.insert()
  end

  @doc """
  Generates a trivia quiz
  """
  def generate_trivia_quiz(quiz_title) do
    ~l"""
    model: gpt-4-1106-preview
    system: You are a quiz generator that generates fun and interesting trivia quizzes"
    Each quiz will be a trivia quiz with 5 questions.
    Each of the questions on the quiz should have 4 possible answers, numbered 1-4.
    The questions should be of a difficulty level appropriate for an adult.
    Each question should have a brief explanation about the correct answer.
    I will give you the title of the quiz and you will generate all the data for the quiz with questions on that topic.
    Please generate the quiz in JSON format like the example below.
    Respond ONLY with the JSON with no additional text.

    User: "Title: What kind of superhero are you? Outcomes: 5"

    You:

    {
      "title": "Marvel Superheroes Trivia Quiz",
      "type": "trivia",
      "questions": [
        {
          "text": "What is the name of Thor's hammer?",
          "correct": 1,
          "explanation": "Mjolnir is the name of Thor's hammer.",
          "answers": [
            { "text": "Mjolnir", "number": 1 },
            { "text": "Stormbreaker", "number": 2 },
            { "text": "Axe of Angarruumus", "number": 3 },
            { "text": "The Destroyer", "number": 4 }
          ]
        }
      // 4 more questions...
      ]
    }

    User: Title: #{quiz_title}
    """
    |> chat()
    |> decode_response()
    |> dbg()

    # |> create_changeset()
    # |> Repo.insert()
  end

  defp decode_response({:ok, json}) do
    Jason.decode!(json)
  end

  defp create_changeset(attrs) do
    Quiz.changeset(%Quiz{}, attrs)
  end
end
