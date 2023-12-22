defmodule KQ.Fixtures.StabilityAiFixtures do
  use KQ.DataCase, only: [assert: 2]
  import Mox
  alias KQ.StabilityAi.MockClient

  def text_to_image_response do
    {:ok,
     %Req.Response{
       status: 200,
       headers: %{
         "alt-svc" => ["h3=\":443\"; ma=86400"],
         "cf-cache-status" => ["DYNAMIC"],
         "cf-ray" => ["835ac104dd2382b6-IAD"],
         "connection" => ["keep-alive"],
         "content-type" => ["application/json"],
         "date" => ["Fri, 15 Dec 2023 01:01:19 GMT"],
         "server" => ["cloudflare"],
         "set-cookie" => [
           "__cf_bm=Sfa_zHOhmcUMezrGYBwpzlw9pCjjjDU8c7Gg2oEYtAo-1702602079-1-AfXGGd4AYd6fxGG6V51lBV0nAjAVNrMobxBi8LsT39X4jX798MlXiMu7+/cAld85V1XwerdifqIIKYFDwvN94g4=; path=/; expires=Fri, 15-Dec-23 01:31:19 GMT; domain=.stability.ai; HttpOnly; Secure; SameSite=None"
         ],
         "transfer-encoding" => ["chunked"],
         "vary" => ["Origin"],
         "x-envoy-upstream-service-time" => ["7385"]
       },
       body: %{
         "artifacts" => [
           %{
             "base64" =>
               "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",
             "finishReason" => "SUCCESS",
             "seed" => 953_806_256
           }
         ]
       },
       trailers: %{},
       private: %{}
     }}
  end

  @doc """
  Set up mock client to expect a text to image request with the given prompt
  """
  def expect_text_to_image_request(prompt) do
    MockClient
    |> expect(:post, fn _url, options ->
      json = Keyword.get(options, :json)
      assert %{text_prompts: prompts} = json
      assert Enum.any?(prompts, &(&1[:text] == prompt))
      text_to_image_response()
    end)
  end
end
