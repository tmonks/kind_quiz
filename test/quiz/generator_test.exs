defmodule KQ.GeneratorTest do
  use KQ.DataCase, async: false

  import KQ.Factory
  import KQ.Fixtures.OpenAI

  alias KQ.Generator

  setup do
    bypass = Bypass.open(port: 4010)
    {:ok, bypass: bypass}
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
      quiz = insert(:quiz, title: "Test Quiz")

      json_response =
        chat_response_outcomes() |> elem(1) |> Jason.encode!()

      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, json_response)
      end)

      assert {:ok, outcomes} = Generator.generate_outcomes(quiz, 3)
      assert length(outcomes) == 4
      assert %{"text" => _, "description" => _, "number" => _} = Enum.at(outcomes, 0)
    end
  end
end
