defmodule KQ.BuilderTest do
  use KQ.DataCase, async: true

  import Mox
  import KQ.Factory
  import KQ.Fixtures.StabilityAiFixtures

  alias KQ.Builder
  alias KQ.StabilityAi.MockClient

  setup :verify_on_exit!

  describe "build_category_quiz/1" do
    test "creates a quiz from the specified title" do
      {:ok, quiz} = Builder.build_category_quiz("Test Quiz")

      assert quiz.title == "Test Quiz"
    end
  end

  describe "add_image/1" do
    test "can generate and add an image to an outcome" do
      outcome = insert(:outcome, image_prompt: "picture of a cat", image: nil)

      MockClient |> expect_text_to_image_request("picture of a cat")

      {:ok, outcome} = Builder.add_image(outcome)
      assert not is_nil(outcome.image)
    end
  end

  defp expect_text_to_image_request(mock_client, prompt) do
    mock_client
    |> expect(:post, fn _url, options ->
      json = Keyword.get(options, :json)
      assert %{text_prompts: prompts} = json
      assert Enum.any?(prompts, &(&1[:text] == prompt))
      text_to_image_response()
    end)
  end
end
