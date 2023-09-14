defmodule QuizWeb.QuizLive do
  use QuizWeb, :live_view

  alias Quiz.Questions

  @impl true
  def mount(_params, _session, socket) do
    questions = Questions.get_questions()
    title = Questions.get_title()

    {:ok,
     socket
     |> assign(questions: questions)
     |> assign(title: title)}
  end

  @impl true
  def handle_event("submit", params, socket) do
    outcome = get_most_frequent_answer(params)

    {:noreply, push_redirect(socket, to: ~p"/outcome/#{outcome}")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="mt-0 mb-8 text-4xl font-medium leading-tight text-primary">
        <%= @title %>
      </h1>
      <form id="quiz-form" phx-submit="submit">
        <%= for {question, index} <- Enum.with_index(@questions) do %>
          <.question_component
            id={"question-#{index}"}
            text={question.text}
            answers={question.answers}
          />
        <% end %>
        <div>
          <button
            type="submit"
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            Submit
          </button>
        </div>
      </form>
    </div>
    """
  end

  @doc """
  Renders a question with a radio button for each answer.
  """
  def question_component(assigns) do
    ~H"""
    <div id={@id} class="pb-6">
      <div class="pb-2"><%= @text %></div>
      <%= for {answer, index} <- Enum.with_index(@answers) do %>
        <div class="pb-1">
          <label>
            <input type="radio" name={@id} value={index} />
            <span><%= answer %></span>
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
