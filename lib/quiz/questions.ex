defmodule Quiz.Questions do
  @moduledoc """
  Loads questions from a CSV file.
  """

  @default_quiz  "./assets/quiz.csv"

  @doc """
  Returns an array of questions and answers.
  """
  def get_questions(csv_path \\ @default_quiz) do
    decode_csv(csv_path)
    # drop the top row
    |> Enum.drop(1)
    |> Enum.map(fn [question | answers] ->
      %{text: question, answers: answers}
    end)
  end

  @doc """
  Returns the title of the quiz.
  """
  def get_title(csv_path \\ @default_quiz) do
    decode_csv(csv_path)
    |> Enum.take(1)
    |> Enum.map(fn [title | _] -> title end)
    |> List.first()
  end


  defp decode_csv(csv_path) do
    csv_path
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode!()
  end
end
