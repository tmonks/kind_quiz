defmodule KQ.BuilderTest do
  use KQ.DataCase, async: true

  alias KQ.Builder

  describe "build_category_quiz/1" do
    test "creates a quiz from the specified title" do
      {:ok, quiz} = Builder.build_category_quiz("Test Quiz")

      assert quiz.title == "Test Quiz"
    end
  end
end
