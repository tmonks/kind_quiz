defmodule KQWeb.TriviaQuizLive do
  use KQWeb, :live_view
  import Phoenix.HTML.Form

  alias KQ.Quizzes

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    quiz = Quizzes.get_quiz!(id)
    question = Enum.at(quiz.questions, 0)
    # only assign answers once connected, so we don't see the shuffling 😅
    answers = if connected?(socket), do: get_shuffled_answers(question), else: []

    form = to_form(%{"response" => nil})

    {:ok,
     socket
     |> assign(quiz: quiz)
     |> assign(index: 0)
     |> assign(form: form)
     |> assign(counts: %{})
     |> assign(question: question)
     |> assign(answers: answers)
     |> assign(button_disabled: true)
     |> assign(submitted_answer: nil)
     |> assign(correct_count: 0)
     |> assign(final_score: nil)}
  end

  @impl true
  def handle_event("select", params, socket) do
    form = to_form(params)
    {:noreply, assign(socket, form: form, button_disabled: false)}
  end

  def handle_event("submit", %{"response" => response}, socket) do
    question = socket.assigns.question
    correct_count = socket.assigns.correct_count
    submitted_answer = String.to_integer(response)

    correct_count =
      if submitted_answer == question.correct,
        do: correct_count + 1,
        else: correct_count

    socket =
      socket
      |> assign(correct_count: correct_count)
      |> assign(submitted_answer: submitted_answer)

    {:noreply, socket}
  end

  def handle_event("next", _params, socket) do
    quiz = socket.assigns.quiz
    response = socket.assigns.submitted_answer
    index = socket.assigns.index + 1
    question = Enum.at(quiz.questions, index)

    # remove this
    counts = Map.update(socket.assigns.counts, response, 1, &(&1 + 1))

    socket =
      if index == length(quiz.questions) do
        final_score = socket.assigns.correct_count / length(quiz.questions) * 100
        final_score = Float.round(final_score) |> trunc()

        socket |> assign(final_score: final_score)
      else
        socket
        |> assign(index: index)
        |> assign(form: to_form(%{"response" => nil}))
        |> assign(question: question)
        |> assign(answers: get_shuffled_answers(question))
        |> assign(button_disabled: true)
        |> assign(counts: counts)
        |> assign(submitted_answer: nil)
      end

    {:noreply, socket}
  end

  defp get_shuffled_answers(question) do
    question.answers
    |> Enum.shuffle()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="mt-0 mb-8 text-4xl font-medium leading-tight text-primary">
        <%= @quiz.title %>
      </h1>
      <%= if @final_score do %>
        <.quiz_score final_score={@final_score} />
      <% else %>
        <.form :let={f} id="quiz-form" for={@form} phx-submit="submit" phx-change="select">
          <div class="pb-6">
            <div id="question-text" class="pb-1 text-lg font-medium"><%= @question.text %></div>
            <div id="question-counter" class="pb-5 text-sm text-gray-600">
              (<%= @index + 1 %> of <%= length(@quiz.questions) %>)
            </div>
            <%= for answer <- @answers do %>
              <div class="pb-2">
                <!-- TODO: figure out how to avoid conflict with KQWeb.CoreComponents.label -->
                <%= Phoenix.HTML.Form.label do %>
                  <%= radio_button(f, :response, answer.number,
                    class: "mr-2",
                    id: "answer-#{answer.id}",
                    disabled: not is_nil(@submitted_answer)
                  ) %>
                  <%= answer.text %>
                <% end %>
              </div>
            <% end %>
            <%= if not is_nil(@submitted_answer) do %>
              <div id="result" class="pt-2">
                <%= if @submitted_answer == @question.correct do %>
                  <span class="font-medium text-green-600">Correct!</span> <%= @question.explanation %>
                <% else %>
                  <span class="font-medium text-red-600">Incorrect.</span> <%= @question.explanation %>
                <% end %>
              </div>
            <% end %>
          </div>
          <div>
            <%= if is_nil(@submitted_answer) do %>
              <!-- SUBMIT BUTTON -->
              <button
                id="submit-button"
                type="submit"
                class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded disabled:opacity-50 disabled:hover:bg-blue-500"
                disabled={@button_disabled}
              >
                Submit
              </button>
            <% end %>
          </div>
        </.form>
      <% end %>
      <%= if not is_nil(@submitted_answer) and is_nil(@final_score) do %>
        <!-- NEXT BUTTON -->
        <button
          id="next-button"
          phx-click="next"
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded disabled:opacity-50 disabled:hover:bg-blue-500"
        >
          Next
        </button>
      <% end %>
    </div>
    """
  end

  defp quiz_score(assigns) do
    ~H"""
    <div>
      <div id="score" class="text-3xl font-medium pb-6">
        Your score: <%= @final_score %>%
      </div>
      <a
        id="home-button"
        type="button"
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded disabled:opacity-50 disabled:hover:bg-blue-500"
        href="/"
      >
        Home
      </a>
    </div>
    """
  end
end
