defmodule KindQuiz.Seeder do
  alias KindQuiz.Repo
  alias KindQuiz.Quizzes.Answer
  alias KindQuiz.Quizzes.Outcome
  alias KindQuiz.Quizzes.Question
  alias KindQuiz.Quizzes.Quiz

  def run do
    delete_all()

    json = File.read!("priv/repo/quiz.json")

    quizzes = Jason.decode!(json)

    for quiz <- quizzes do
      Quiz.changeset(%Quiz{}, quiz)
      |> Repo.insert!()
    end
  end

  defp delete_all do
    Repo.delete_all(Answer)
    Repo.delete_all(Outcome)
    Repo.delete_all(Question)
    Repo.delete_all(Quiz)
  end
end
