defmodule Quiz.Questions do
  @moduledoc """
  Loads questions from a CSV file.
  """

  @doc """
  Returns an array of questions and answers.
  """
  def get_questions do
    decode_csv()
    # drop the top row
    |> Enum.drop(1)
    |> Enum.map(fn [question | answers] ->
      %{text: question, answers: answers}
    end)
  end

  @doc """
  Returns the title of the quiz.
  """
  def get_title do
    decode_csv()
    |> Enum.take(1)
    |> Enum.map(fn [title | _] -> title end)
    |> List.first()
  end

  @doc """
  Returns the list of possible outcomes
  """
  def list_outcomes do
    decode_csv()
    |> Enum.at(0)
    |> Enum.drop(1)
  end

  @doc """
  Returns the outcome with the given id. Raises an error if the id is invalid.
  """
  def get_outcome!(id) do
    outcome =
      decode_csv()
      |> Enum.at(0)
      |> Enum.drop(1)
      |> Enum.at(id)

    case outcome do
      nil -> raise ArgumentError, "Invalid outcome id"
      _ -> outcome
    end
  end

  defp decode_csv() do
    Application.get_env(:quiz, :quiz_path)
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode!()
  end
end
