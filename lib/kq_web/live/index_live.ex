defmodule KQWeb.IndexLive do
  use KQWeb, :live_view

  alias KQ.Quizzes

  @impl true
  def mount(_params, _session, socket) do
    quizzes =
      if socket.assigns.is_admin do
        Quizzes.list_quizzes()
      else
        Quizzes.list_active_quizzes()
      end

    {:ok, assign(socket, quizzes: quizzes)}
  end

  @impl true
  def handle_event("toggle-active", %{"id" => quiz_id}, socket) do
    quiz_id = String.to_integer(quiz_id)
    quiz = get_quiz_from_assigns(socket, quiz_id)
    {:ok, quiz} = Quizzes.toggle_active(quiz)
    socket = update_quiz_in_assigns(socket, quiz)
    {:noreply, socket}
  end

  defp get_quiz_from_assigns(socket, quiz_id) do
    Enum.find(socket.assigns.quizzes, &(&1.id == quiz_id))
  end

  defp update_quiz_in_assigns(socket, quiz) do
    quizzes = Enum.map(socket.assigns.quizzes, &if(&1.id == quiz.id, do: quiz, else: &1))
    socket |> assign(:quizzes, quizzes)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <%= for quiz <- @quizzes do %>
        <!-- Card -->
        <a id={"quiz-#{quiz.id}-link"} href={get_quiz_link(quiz)}>
          <div id={"quiz-#{quiz.id}"} class="max-w-sm rounded overflow-hidden shadow-lg h-full">
            <img class="w-full" src={get_image_path(quiz)} />
            <div class="px-6 py-4">
              <div class="text-xl font-bold mb-2">
                <%= quiz.title %>
              </div>
              <%= if @is_admin do %>
              <div>
                <label>
                  <input
                    type="checkbox"
                    phx-click="toggle-active"
                    phx-value-id={quiz.id}
                    checked={quiz.is_active}
                  /> Active
                </label>
              </div>
              <% end %>
            </div>
          </div>
        </a>
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
  defp get_image_path(%{image: image}), do: "images/quiz/#{image}"
end
