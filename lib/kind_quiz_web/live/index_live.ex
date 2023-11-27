defmodule KindQuizWeb.IndexLive do
  use KindQuizWeb, :live_view

  alias KindQuiz.Quizzes

  @impl true
  def mount(_params, _session, socket) do
    quizzes = Quizzes.list_quizzes()
    {:ok, assign(socket, quizzes: quizzes)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <%= for quiz <- @quizzes do %>
        <!-- Card -->
        <div id={"quiz-#{quiz.id}"} class="max-w-sm rounded overflow-hidden shadow-lg">
          <img class="w-full" src={get_image_path(quiz)} />
          <div class="px-6 py-4">
            <div class="text-xl font-bold mb-2">
              <a id={"quiz-#{quiz.id}-link"} href={get_quiz_link(quiz)}>
                <%= quiz.title %>
              </a>
            </div>
            <div></div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp get_quiz_link(quiz) do
    if quiz.type == :trivia do
      ~p"/trivia/#{quiz.id}"
    else
      ~p"/quiz/#{quiz.id}"
    end
  end

  defp get_image_path(%{image: nil}), do: "images/placeholder.png"
  defp get_image_path(%{image: image}), do: "images/#{image}"
end
