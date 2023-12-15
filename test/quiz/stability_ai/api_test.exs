defmodule KindQuiz.StabilityAi.ApiTest do
  use KindQuizWeb.ConnCase, async: true

  import Mox
  alias KindQuiz.StabilityAi.Api
  alias KindQuiz.StabilityAi.MockClient

  setup [:verify_on_exit!, :set_api_key]

  describe "generate_image/1" do
    test "sends a post request with the expected params to the API" do
      MockClient
      |> expect(:post, fn url, options ->
        assert url ==
                 "https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image"

        assert {"Authorization", "Bearer StaB1l1tyA1"} in options[:headers]
        assert {"Content-Type", "application/json"} in options[:headers]
        assert {"Accept", "application/json"} in options[:headers]
      end)

      assert {:ok, "something"} = Api.generate_image("a cute fluffy cat")
    end
  end

  defp set_api_key(_) do
    Application.put_env(:kind_quiz, :stability_ai_api_key, "StaB1l1tyA1")
  end
end
