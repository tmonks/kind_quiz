defmodule KindQuizWeb.TriviaQuizLive do
  use KindQuizWeb, :live_view
  import Phoenix.HTML.Form

  alias KindQuiz.Questions

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    quiz = get_trivia_quiz()
    title = Questions.get_title()
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
     |> assign(title: title)
     |> assign(button_disabled: true)
     |> assign(submitted_answer: nil)
     |> assign(correct_count: 0)}
  end

  @impl true
  def handle_event("select", params, socket) do
    form = to_form(params)
    {:noreply, assign(socket, form: form, button_disabled: false)}
  end

  def handle_event("submit", %{"response" => response}, socket) do
    question = socket.assigns.question
    IO.inspect(question.correct, label: "actually correct")
    correct_count = socket.assigns.correct_count
    submitted_answer = String.to_integer(response) |> IO.inspect(label: "submitted_answer")

    correct_count =
      if submitted_answer == question.correct,
        do: correct_count + 1,
        else: correct_count |> IO.inspect(label: "correct_count")

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
        outcome = most_frequent_response(counts)
        socket |> redirect(to: ~p"/quiz/#{quiz.id}/outcome/#{outcome}")
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

  defp most_frequent_response(counts) do
    counts
    |> Enum.max_by(fn {_k, v} -> v end)
    |> elem(0)
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
      <.form :let={f} id="quiz-form" for={@form} phx-submit="submit" phx-change="select">
        <div class="pb-6">
          <div id="correct-count" class="pb-1 text-lg font-medium">
            Correct so far: <%= @correct_count %>
          </div>
          <div id="question-text" class="pb-1 text-lg font-medium"><%= @question.text %></div>
          <div id="question-counter" class="pb-5 text-sm text-gray-600">
            (<%= @index + 1 %> of <%= length(@quiz.questions) %>)
          </div>
          <%= for answer <- @answers do %>
            <div class="pb-2">
              <!-- TODO: figure out how to avoid conflict with KindQuizWeb.CoreComponents.label -->
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
        </div>
        <%= if not is_nil(@submitted_answer) do %>
          <div id="result">
            <%= if @submitted_answer == @question.correct do %>
              Correct! <%= @question.explanation %>
            <% else %>
              Incorrect. <%= @question.explanation %>
            <% end %>
          </div>
        <% end %>
        <div>
          <%= if is_nil(@submitted_answer) do %>
            <button
              id="submit-button"
              type="submit"
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded disabled:opacity-50 disabled:hover:bg-blue-500"
              disabled={@button_disabled}
            >
              Submit
            </button>
          <% else %>
            <button
              id="next-button"
              phx-click="next"
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded disabled:opacity-50 disabled:hover:bg-blue-500"
            >
              Next
            </button>
          <% end %>
        </div>
      </.form>
    </div>
    """
  end

  defp get_trivia_quiz() do
    %{
      outcomes: [
        %{id: 1, number: 1, text: "Spider-Man"},
        %{id: 2, number: 2, text: "Black Widow"},
        %{id: 3, number: 3, text: "Captain Marvel"},
        %{id: 4, number: 4, text: "Hulk"},
        %{id: 5, number: 5, text: "Doctor Strange"}
      ],
      questions: [
        %{
          answers: [
            %{id: 1, number: 1, text: "Red"},
            %{id: 2, number: 2, text: "Black"},
            %{id: 3, number: 3, text: "Blue"},
            %{id: 4, number: 4, text: "Green"},
            %{id: 5, number: 5, text: "Purple"}
          ],
          text: "What is your favorite color?",
          correct: 1,
          explanation: "Black Widow is a master spy and assassin."
        },
        %{
          answers: [
            %{id: 1, number: 1, text: "Swinging on webs"},
            %{id: 2, number: 2, text: "Driving a fast car"},
            %{id: 3, number: 3, text: "Flying"},
            %{id: 4, number: 4, text: "Running or jumping"},
            %{id: 5, number: 5, text: "Teleporting"}
          ],
          text: "What is your preferred method of transportation?",
          correct: 2,
          explanation: "Some brilliant explanation"
        },
        %{
          answers: [
            %{id: 1, number: 1, text: "Friendly and witty"},
            %{id: 2, number: 2, text: "Mysterious and skilled"},
            %{id: 3, number: 3, text: "Confident and powerful"},
            %{id: 4, number: 4, text: "Strong and tough"},
            %{id: 5, number: 5, text: "Intelligent and wise"}
          ],
          text: "How would you describe your personality?",
          correct: 3,
          explanation: "Some brilliant explanation"
        },
        %{
          answers: [
            %{id: 1, number: 1, text: "Sunny"},
            %{id: 2, number: 2, text: "Rainy"},
            %{id: 3, number: 3, text: "Stormy"},
            %{id: 4, number: 4, text: "Cloudy"},
            %{id: 5, number: 5, text: "Foggy"}
          ],
          text: "What is your favorite type of weather?",
          correct: 4,
          explanation: "Some brilliant explanation"
        },
        %{
          answers: [
            %{id: 1, number: 1, text: "Make jokes and lighten the mood"},
            %{id: 2, number: 2, text: "Analyze the situation and come up with a plan"},
            %{id: 3, number: 3, text: "Use your powers or skills to take charge"},
            %{id: 4, number: 4, text: "Use brute force and smash through obstacles"},
            %{id: 5, number: 5, text: "Use your magic or mystical abilities"}
          ],
          text: "How do you handle difficult situations?",
          correct: 5,
          explanation: "Some brilliant explanation"
        }
      ],
      title: "What Marvel superhero are you?"
    }
  end
end