defmodule KindQuiz.StabilityAi.Api do
  alias KindQuiz.StabilityAi.Client

  def generate_image(prompt) do
    url = "https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image"

    headers =
      [
        {"Authorization", "Bearer #{get_api_key()}"},
        {"Content-Type", "application/json"},
        {"Accept", "application/json"}
      ]

    timeout = 120_000

    body = %{
      steps: 40,
      width: 1024,
      height: 1024,
      seed: 0,
      cfg_scale: 5,
      samples: 1,
      style_preset: "enhance",
      text_prompts: [
        %{text: prompt, weight: 1},
        %{text: "blurry, bad", weight: -1}
      ]
    }

    Client.post(url, json: body, headers: headers, receive_timeout: timeout)
  end

  defp get_api_key() do
    Application.get_env(:quiz, :stability_ai_api_key)
  end
end
