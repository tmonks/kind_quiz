defmodule KindQuizWeb.QuizLive do
  use KindQuizWeb, :live_view
  import Phoenix.HTML.Form

  alias KindQuiz.Questions

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    quiz = Questions.get_quiz!(id)
    title = Questions.get_title()

    form = to_form(%{"response" => nil})

    {:ok,
     socket
     |> assign(quiz: quiz)
     |> assign(index: 0)
     |> assign(form: form)
     |> assign(counts: %{})
     |> assign(question: Enum.at(quiz.questions, 0))
     |> assign(title: title)
     |> assign(button_disabled: true)}
  end

  @impl true
  def handle_event("select", params, socket) do
    form = to_form(params)
    {:noreply, assign(socket, form: form, button_disabled: false)}
  end

  def handle_event("next", %{"response" => response}, socket) do
    quiz = socket.assigns.quiz
    response = String.to_integer(response)
    counts = Map.update(socket.assigns.counts, response, 1, &(&1 + 1))
    index = socket.assigns.index + 1

    socket =
      if index == length(quiz.questions) do
        outcome = most_frequent_response(counts)
        socket |> redirect(to: ~p"/quiz/#{quiz.id}/outcome/#{outcome}")
      else
        socket
        |> assign(index: index)
        |> assign(form: to_form(%{"response" => nil}))
        |> assign(question: Enum.at(quiz.questions, index))
        |> assign(button_disabled: true)
        |> assign(counts: counts)
      end

    {:noreply, socket}
  end

  defp most_frequent_response(counts) do
    counts
    |> Enum.max_by(fn {_k, v} -> v end)
    |> elem(0)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="mt-0 mb-8 text-4xl font-medium leading-tight text-primary">
        <%= @quiz.title %>
      </h1>
      <.form :let={f} id="quiz-form" for={@form} phx-submit="next" phx-change="select">
        <div class="pb-6">
          <div id="question-text" class="pb-1 text-lg font-medium"><%= @question.text %></div>
          <div id="question-counter" class="pb-5 text-sm text-gray-600">
            (<%= @index + 1 %> of <%= length(@quiz.questions) %>)
          </div>
          <%= for answer <- @question.answers do %>
            <div class="pb-2">
              <!-- TODO: figure out how to avoid conflict with KindQuizWeb.CoreComponents.label -->
              <%= Phoenix.HTML.Form.label do %>
                <%= radio_button(f, :response, answer.number,
                  class: "mr-2",
                  id: "answer-#{answer.id}"
                ) %>
                <%= answer.text %>
              <% end %>
            </div>
          <% end %>
        </div>
        <div>
          <button
            id="next-button"
            type="submit"
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded disabled:opacity-50 disabled:hover:bg-blue-500"
            disabled={@button_disabled}
          >
            Next
          </button>
        </div>
      </.form>
    </div>
    """
  end
end
