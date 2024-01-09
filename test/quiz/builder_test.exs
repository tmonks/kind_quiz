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
    test "uses OpenAI and StabilityAI to build a complete category quiz", %{bypass: bypass} do
      {:ok, agent} = Agent.start_link(fn -> 1 end)
      counter_fn = fn -> Agent.get_and_update(agent, fn x -> {x, x + 1} end) end

      Bypass.expect(bypass, "POST", "/v1/chat/completions", fn conn ->
        case counter_fn.() do
          1 ->
            Plug.Conn.resp(conn, 200, chat_response_category_quiz())

          2 ->
            Plug.Conn.resp(conn, 200, chat_response_image_prompt("Prompt for cover image"))

          _ ->
            raise "Unexpected call to OpenAI"
        end
      end)

      # Call to StabilityAI to generate cover image
      expect_text_to_image_request("Prompt for cover image")

      # Call to StabilityAI 5 more times to generate outcome images
      expect_text_to_image_request("Prompt for Cheese Pizza outcome")
      expect_text_to_image_request("Prompt for Pepperoni Pizza outcome")
      expect_text_to_image_request("Prompt for Veggie Pizza outcome")
      expect_text_to_image_request("Prompt for Hawaiian Pizza outcome")
      expect_text_to_image_request("Prompt for Meat Lovers Pizza outcome")

      {:ok, quiz} =
        Builder.build_category_quiz("What kind of pizza are you?",
          outcome_image_prompt: "Prompt for {{outcome}} outcome"
        )

      assert quiz.title == "What kind of pizza are you?"
      assert quiz.image_prompt == "Prompt for cover image"
      assert quiz.image =~ ~r/img.*png/
      assert [outcome1 | _] = quiz.outcomes
      assert outcome1.text == "Cheese Pizza"
      assert outcome1.image_prompt == "Prompt for Cheese Pizza outcome"
      assert outcome1.image =~ ~r/img.*png/
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

    test "can generate and add an image to a quiz" do
      quiz = insert(:quiz, image_prompt: "picture of a cat", image: nil)

      expect_text_to_image_request("picture of a cat")

      {:ok, quiz} = Builder.add_image(quiz)
      assert quiz.image =~ ~r/img.*png/
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
