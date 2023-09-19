defmodule QuizWeb.QuizLive do
  use QuizWeb, :live_view
  import Phoenix.HTML.Form

  alias Quiz.Questions

  @impl true
  def mount(_params, _session, socket) do
    questions = Questions.get_questions()
    title = Questions.get_title()

    form = to_form(%{"response" => nil})

    {:ok,
     socket
     |> assign(index: 0)
     |> assign(form: form)
     |> assign(question: Enum.at(questions, 0))
     |> assign(questions: questions)
     |> assign(title: title)
     |> assign(button_disabled: true)}
  end

  @impl true
  def handle_event("submit", params, socket) do
    outcome = get_most_frequent_answer(params)

    {:noreply, push_redirect(socket, to: ~p"/outcome/#{outcome}")}
  end

  def handle_event("select", params, socket) do
    form = to_form(params)
    {:noreply, assign(socket, form: form, button_disabled: false)}
  end

  def handle_event("next", _params, socket) do
    index = socket.assigns.index + 1
    question = Enum.at(socket.assigns.questions, index)

    {:noreply, assign(socket, index: index, question: question, button_disabled: true)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="mt-0 mb-8 text-4xl font-medium leading-tight text-primary">
        <%= @title %>
      </h1>
      <.form :let={f} id="quiz-form" for={@form} phx-submit="submit" phx-change="select">
        <div class="pb-6">
          <div id="question-text" class="pb-4 text-lg font-medium"><%= @question.text %></div>
          <%= for {answer, index} <- Enum.with_index(@question.answers) do %>
            <div class="pb-2">
              <label>
                <%= radio_button(f, :response, index) %>
                <span class="ml-2"><%= answer %></span>
              </label>
            </div>
          <% end %>
        </div>
      </.form>
      <div>
        <button
          id="next-button"
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded disabled:opacity-50 disabled:hover:bg-blue-500"
          phx-click="next"
          disabled={@button_disabled}
        >
          Next
        </button>
      </div>
    </div>
    """
  end

  @doc """
  Renders a question with a radio button for each answer.
  """
  def question_component(assigns) do
    ~H"""
    <div id={@id} class="pb-6">
      <div class="pb-4 text-lg font-medium"><%= @text %></div>
      <%= for {answer, index} <- Enum.with_index(@answers) do %>
        <div class="pb-2">
          <label>
            <input type="radio" name={@id} value={index} />
            <span class="ml-2"><%= answer %></span>
          </label>
        </div>
      <% end %>
    </div>
    """
  end

  defp get_most_frequent_answer(params) do
    params
    |> Enum.group_by(fn {_k, v} -> v end)
    |> Enum.max_by(fn {_k, v} -> Enum.count(v) end)
    |> elem(0)
    |> String.to_integer()
  end
end
