defmodule KQ.GeneratorTest do
  use KQ.DataCase, async: false

  import KQ.Factory
  import KQ.Fixtures.OpenAI

  alias KQ.Generator

  setup do
    bypass = Bypass.open(port: 4010)
    {:ok, bypass: bypass}
  end

  describe "generate_category_quiz/2" do
    test "Generates the params for a category quiz from a title and number of outcomes", %{
      bypass: bypass
    } do
      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, chat_response_category_quiz())
      end)

      assert %{"title" => title, "outcomes" => outcomes, "questions" => questions} =
               Generator.generate_category_quiz("Amazing category quiz", 5)

      assert title == "🍕 What kind of pizza are you?"
      assert length(outcomes) == 5
      assert %{"number" => 1, "text" => _} = Enum.at(outcomes, 0)
      assert length(questions) == 5
      assert %{"text" => _, "answers" => answers} = Enum.at(questions, 0)
      assert length(answers) == 5
    end
  end

  describe "generate_image_prompt/1" do
    test "Generates a text prompt for creating an image for a quiz", %{bypass: bypass} do
      quiz = insert(:quiz, title: "Test Quiz")

      json_response =
        chat_response_image_prompt("Prompt for quiz image") |> elem(1) |> Jason.encode!()

      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, json_response)
      end)

      assert {:ok, prompt} = Generator.generate_image_prompt(quiz)
      assert prompt =~ "Prompt for quiz image"
    end

    test "Generates a text prompt for creating an image for a outcome", %{bypass: bypass} do
      outcome = insert(:outcome)

      json_response =
        chat_response_image_prompt("Prompt for outcome image") |> elem(1) |> Jason.encode!()

      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, json_response)
      end)

      assert {:ok, prompt} = Generator.generate_image_prompt(outcome)
      assert prompt =~ "Prompt for outcome image"
    end
  end

  describe "generate_outcomes/2" do
    test "Generates outcomes for a quiz", %{bypass: bypass} do
      quiz = insert(:quiz, type: :category)

      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, chat_response_outcomes())
      end)

      assert {:ok, outcomes} = Generator.generate_outcomes(quiz, 3)
      assert length(outcomes) == 4
      assert %{"text" => _, "description" => _, "number" => _} = Enum.at(outcomes, 0)
    end

    test "Generates outcomes for a quiz title", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, chat_response_outcomes())
      end)

      assert {:ok, outcomes} = Generator.generate_outcomes("Amazing category quiz", 3)
      assert length(outcomes) == 4
      assert %{"text" => _, "description" => _, "number" => _} = Enum.at(outcomes, 0)
    end
  end

  describe "generate_category_questions/1" do
    test "Generates questions for a category quiz", %{bypass: bypass} do
      quiz = insert(:quiz, type: :category)

      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, chat_response_category_questions())
      end)

      assert {:ok, questions} = Generator.generate_category_questions(quiz)
      assert length(questions) == 5
      assert %{"answers" => _, "text" => _} = Enum.at(questions, 0)
    end

    @tag :skip
    test "Generates questions for a category quiz title", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, chat_response_category_questions())
      end)

      assert {:ok, questions} = Generator.generate_category_questions("Amazing category quiz")
      assert length(questions) == 5
      assert %{"answers" => _, "text" => _} = Enum.at(questions, 0)
    end
  end
end
