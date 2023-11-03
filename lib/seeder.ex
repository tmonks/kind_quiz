defmodule KindQuiz.Seeder do
  alias KindQuiz.Repo
  alias KindQuiz.Quizzes.Answer
  alias KindQuiz.Quizzes.Outcome
  alias KindQuiz.Quizzes.Question
  alias KindQuiz.Quizzes.Quiz

  def run do
    delete_all()

    json = File.read!("priv/repo/quiz.json")

    attrs = Jason.decode!(json)

    Quiz.changeset(%Quiz{}, attrs)
    |> Repo.insert!()
  end

  defp delete_all do
    Repo.delete_all(Answer)
    Repo.delete_all(Outcome)
    Repo.delete_all(Question)
    Repo.delete_all(Quiz)
  end
end
