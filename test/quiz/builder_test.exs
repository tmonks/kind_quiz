defmodule KQ.BuilderTest do
  use KQ.DataCase, async: true

  import Mox
  import KQ.Factory
  import KQ.Fixtures.StabilityAiFixtures
  import KQ.Fixtures.OpenAI

  alias KQ.Builder

  setup :verify_on_exit!

  # setup Bypass for OpenAI calls
  setup do
    bypass = Bypass.open(port: 4010)
    {:ok, bypass: bypass}
  end

  describe "build_category_quiz/1" do
    test "creates a quiz from the specified title", %{bypass: bypass} do
      expected_response = chat_response_outcomes() |> elem(1) |> Jason.encode!()

      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, expected_response)
      end)

      {:ok, quiz} = Builder.build_category_quiz("Test Quiz")

      assert quiz.title == "Test Quiz"
    end

    test "calls OpenAI to generate and add outcomes", %{bypass: bypass} do
      expected_response = chat_response_outcomes() |> elem(1) |> Jason.encode!()

      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, expected_response)
      end)

      {:ok, quiz} = Builder.build_category_quiz("Test Quiz")
      IO.inspect(quiz.outcomes)
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

  describe "add_outcome_images/1" do
    test "adds an image for each outcome" do
      quiz = insert(:quiz, type: :category)

      outcome1 =
        insert(:outcome, quiz: quiz, image_prompt: "picture of a cat", image: nil)

      outcome2 =
        insert(:outcome, quiz: quiz, image_prompt: "picture of a dog", image: nil)

      expect_text_to_image_request("picture of a cat")
      expect_text_to_image_request("picture of a dog")

      {:ok, _quiz} = Builder.add_outcome_images(quiz)
      assert Repo.reload(outcome1) |> Map.get(:image) =~ ~r/img.*png/
      assert Repo.reload(outcome2) |> Map.get(:image) =~ ~r/img.*png/
    end
  end
end
