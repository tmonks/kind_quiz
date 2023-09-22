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
     |> assign(counts: %{})
     |> assign(question: Enum.at(questions, 0))
     |> assign(questions: questions)
     |> assign(title: title)
     |> assign(button_disabled: true)}
  end

  @impl true
  def handle_event("select", params, socket) do
    form = to_form(params)
    {:noreply, assign(socket, form: form, button_disabled: false)}
  end

  def handle_event("next", %{"response" => response}, socket) do
    response = String.to_integer(response)
    counts = Map.update(socket.assigns.counts, response, 1, &(&1 + 1))
    index = socket.assigns.index + 1
    questions = socket.assigns.questions

    socket =
      if index == length(questions) do
        outcome = most_frequent_response(counts)
        socket |> redirect(to: ~p"/outcome/#{outcome}")
      else
        socket
        |> assign(index: index)
        |> assign(form: to_form(%{"response" => nil}))
        |> assign(question: Enum.at(questions, index))
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
        <%= @title %>
      </h1>
      <.form :let={f} id="quiz-form" for={@form} phx-submit="next" phx-change="select">
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
end
