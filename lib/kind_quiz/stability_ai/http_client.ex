defmodule KindQuiz.StabilityAi.HttpClient do
  @behaviour KindQuiz.StabilityAi.Client

  @impl true
  def post(url, options), do: Req.post(url, options)
end
