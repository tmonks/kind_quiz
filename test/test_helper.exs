ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(KQ.Repo, :manual)

Mox.defmock(KQ.StabilityAi.MockClient, for: KQ.StabilityAi.Client)
Application.put_env(:quiz, :stability_ai_client, KQ.StabilityAi.MockClient)
