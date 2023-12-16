defmodule KindQuiz.StabilityAi.Api do
  alias KindQuiz.StabilityAi.Client

  @doc """
  Generates and saves an image for the given prompt.
  Returns the filename.

  Possible params:

  - style_preset: 3d-model, analog-film, anime, cinematic, comic-book, digital-art, enhance, fantasy-art, isometric, line-art, low-poly, modeling-compound, neon-punk, origami, photographic, pixel-art, tile-texture
  """
  def generate_image(prompt, params \\ %{}) do
    model = "stable-diffusion-xl-1024-v1-0"
    url = "https://api.stability.ai/v1/generation/#{model}/text-to-image"
    download_path = Application.get_env(:quiz, :download_path)

    headers =
      [
        {"Authorization", "Bearer #{get_api_key()}"},
        {"Content-Type", "application/json"},
        {"Accept", "application/json"}
      ]

    body =
      %{
        steps: 40,
        width: 1024,
        height: 1024,
        seed: 0,
        cfg_scale: 6,
        samples: 1,
        style_preset: "enhance",
        text_prompts: [
          %{text: prompt, weight: 1},
          %{text: "blurry, bad", weight: -1}
        ]
      }
      |> Map.merge(params)

    {:ok, %Req.Response{body: resp_body}} =
      Client.post(url, json: body, headers: headers, receive_timeout: 120_000)

    %{"artifacts" => [%{"base64" => base64, "seed" => seed}]} = resp_body
    image_data = Base.decode64!(base64)
    filename = make_filename(body.style_preset, seed, prompt)
    File.write!("#{download_path}/#{filename}", image_data)
    {:ok, filename}
  end

  defp make_filename(style_preset, seed, prompt) do
    prompt = prompt |> String.replace(" ", "_")
    base_name = "SD-#{style_preset}-#{seed}-#{prompt}"
    # truncate to 255 characters total
    (base_name |> String.slice(0..250)) <> ".png"
  end

  defp get_api_key() do
    Application.get_env(:quiz, :stability_ai_api_key)
  end
end
