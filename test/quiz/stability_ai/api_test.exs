defmodule KQ.StabilityAi.ApiTest do
  use KQWeb.ConnCase, async: true

  import Mox
  alias KQ.StabilityAi.Api
  alias KQ.StabilityAi.MockClient

  setup [:verify_on_exit!, :setup_environment]

  describe "generate_image/1" do
    test "sends a post request with the expected params to the API" do
      MockClient
      |> expect(:post, fn url, options ->
        assert url ==
                 "https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image"

        assert {"Authorization", "Bearer StaB1l1tyA1"} in options[:headers]
        assert {"Content-Type", "application/json"} in options[:headers]
        assert {"Accept", "application/json"} in options[:headers]

        {:ok,
         %Req.Response{
           body: %{
             "artifacts" => [
               %{
                 "base64" => "Zm9vYmFy",
                 "seed" => 12345
               }
             ]
           }
         }}
      end)

      assert {:ok, "SD-awesome-12345-a_cute_fluffy_cat.png"} =
               Api.generate_image("a cute fluffy cat", %{style_preset: "awesome"})
    end
  end

  defp setup_environment(_) do
    Application.put_env(:quiz, :stability_ai_api_key, "StaB1l1tyA1")
    Application.put_env(:quiz, :download_path, "/tmp")
  end
end
