ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(KindQuiz.Repo, :manual)

Mox.defmock(KindQuiz.StabilityAi.MockClient, for: KindQuiz.StabilityAi.Client)
Application.put_env(:quiz, :stability_ai_client, KindQuiz.StabilityAi.MockClient)
