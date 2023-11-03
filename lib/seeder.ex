defmodule KindQuiz.Seeder do
  alias KindQuiz.Repo
  alias KindQuiz.Quizzes.Answer
  alias KindQuiz.Quizzes.Outcome
  alias KindQuiz.Quizzes.Question
  alias KindQuiz.Quizzes.Quiz

  def run do
    clear_db()

    quiz =
      Quiz.changeset(%Quiz{}, %{title: "What kind of superhero are you?"})
      |> Repo.insert!()
      |> IO.inspect()

    outcome1 = Outcome.changeset(%Outcome{}, %{text: "Captain America"}) |> Repo.insert!()
    outcome2 = Outcome.changeset(%Outcome{}, %{text: "Black Panther"}) |> Repo.insert!()
    outcome3 = Outcome.changeset(%Outcome{}, %{text: "Iron Man"}) |> Repo.insert!()
    outcome4 = Outcome.changeset(%Outcome{}, %{text: "Hawkeye"}) |> Repo.insert!()
    outcome5 = Outcome.changeset(%Outcome{}, %{text: "Thor"}) |> Repo.insert!()

    question_attrs = %{
      text: "What is your favorite subject in school?",
      quiz_id: quiz.id,
      answers: [
        %{text: "History", outcome_id: outcome1.id},
        %{text: "Science", outcome_id: outcome2.id},
        %{text: "Technology", outcome_id: outcome3.id},
        %{text: "Physical Education", outcome_id: outcome4.id},
        %{text: "Mythology", outcome_id: outcome5.id}
      ]
    }

    Question.changeset(%Question{}, question_attrs) |> Repo.insert!()
  end

  defp clear_db do
    Repo.delete_all(Answer)
    Repo.delete_all(Outcome)
    Repo.delete_all(Question)
    Repo.delete_all(Quiz)
  end
end
