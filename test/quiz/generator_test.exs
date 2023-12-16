defmodule KQ.GeneratorTest do
  use KQ.DataCase, async: true

  import KQ.Factory
  import KQ.Fixtures.OpenAI

  alias KQ.Generator

  setup do
    bypass = Bypass.open(port: 4010)
    {:ok, bypass: bypass}
  end

  describe "generate_image_prompt/1" do
    test "Returns a prompt for generating an image for a quiz", %{bypass: bypass} do
      quiz = insert(:quiz, title: "Test Quiz")
      json_response = chat_response_image_prompt() |> elem(1) |> Jason.encode!()

      Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
        Plug.Conn.resp(conn, 200, json_response)
      end)

      assert {:ok, prompt} = Generator.generate_image_prompt(quiz)
      assert prompt =~ "Fantasy illustration of an enchanted Thanksgiving feast table"
    end
  end
end
