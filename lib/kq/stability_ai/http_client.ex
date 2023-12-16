defmodule KQ.StabilityAi.HttpClient do
  @behaviour KQ.StabilityAi.Client

  @impl true
  def post(url, options), do: Req.post(url, options)
end
