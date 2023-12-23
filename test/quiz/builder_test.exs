defmodule KQ.BuilderTest do
  use KQ.DataCase, async: true

  import Mox
  import KQ.Factory
  import KQ.Fixtures.StabilityAiFixtures

  alias KQ.Builder

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
      date = Date.utc_today() |> Date.to_iso8601() |> String.replace("-", "")

      expect_text_to_image_request("picture of a cat")

      {:ok, outcome} = Builder.add_image(outcome)
      # image named with date and seed
      assert outcome.image == "img-#{date}-953806256.png"
    end
  end
end
