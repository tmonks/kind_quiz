defmodule KQ.Generator do
  @moduledoc """
  Generatez quizzes and questions using OpenAI API
  """

  alias KQ.Quizzes.Outcome
  alias KQ.Quizzes.Quiz
  alias KQ.Repo

  @models %{
    gpt3: "gpt-3.5-turbo-1106",
    gpt4: "gpt-4-1106-preview"
  }

  @doc """
  Generates a category quiz
  """
  def generate_category_quiz(quiz_title, outcomes \\ 5) do
    outcome_text =
      if is_list(outcomes) do
        Enum.join(outcomes, ", ")
      else
        outcomes
      end

    system_prompt = """
    You are a quiz generator that generates fun quizzes for 10-14 year old children.
    The quiz will attempt to categorize the taker in some way based on their responses.
    The quiz should have 5 questions.
    The quiz will have a certain number of possible outcomes (i.e. categories that the taker can be placed in).
    Each question should have a number of possible answers equal to the number of possible outcomes.
    The most frequently selected answer number will determine the outcome.
    Each question's answer `number` 1 will correspond to the outcome with `number` 1, and so on.
    The answers should be brief, not too wordy, and easy for a 10-year old to understand.
    Insert a relevant emoji at the beginning of the title.
    I will give you the title of the quiz, and either the specific outcomes or the number of outcomes for you to make up.
    Please generate the quiz in JSON format like the example below.
    Respond ONLY with the valid JSON and no additional text.

    User: "Title: What kind of superhero are you? Outcomes: 5"

    You:

    {
      "title": "🦸 What kind of superhero are you?",
      "type": "category",
      "outcomes": [
        { "number": 1, "text": "Captain America" },
        { "number": 2, "text": "Black Panther" },
        { "number": 3, "text": "Iron Man" },
        { "number": 4, "text": "Hawkeye" },
        { "number": 5, "text": "Thor" }
      ],
      "questions": [
        {
          "text": "How do you like to spend your free time?",
          "answers": [
            { "text": "Helping others", "number": 1 },
            { "text": "Studying or reading", "number": 2 },
            { "text": "Inventing or building things", "number": 3 },
            { "text": "Practicing archery or other sports", "number": 4 },
            { "text": "Exploring the outdoors", "number": 5 }
          ]
        }
      ]
      // 4 more questions...
    }
    """

    user_prompt = "Title: #{quiz_title}, Outcomes: #{outcome_text}"

    get_completion(@models[:gpt4], system_prompt, user_prompt,
      temperature: 0.8,
      response_format: %{type: "json_object"}
    )
    |> parse_chat()
    |> decode_json()
  end

  @doc """
  Generates a set of outcomes for a category quiz
  """
  def generate_outcomes(title, outcomes \\ 5)

  def generate_outcomes(%Quiz{} = quiz, outcomes) do
    generate_outcomes(quiz.title, outcomes)
  end

  def generate_outcomes(quiz_title, outcomes) do
    system_prompt =
      """
      Please generate possible outcomes for a personality quiz.
      The outcomes should be numbered in order.
      Each outcome should have a brief description of the type of person that would get that outcome.
      I will give you the title of the quiz and the number of required outcomes.
      Generate only valid JSON with no additional text.

      Example:

      User: "Quiz title: What kind of spirit animal are you?, Outcomes: 4"

      You:

      {
        outcomes: [
          { "number": 1, "text": "Wolf", "description": "You're a natural-born leader with a strong sense of loyalty and a desire for freedom. You value deep connections with others and are not afraid to face challenges head-on." },
          { "number": 2, "text": "Bear", "description": "You exude confidence and strength, preferring solitude or a small circle of close friends. Your resilience and protective nature make you a powerful presence to those around you." },
          { "number": 3, "text": "Eagle" "description": "Your perspective is unique, offering you insight that others may lack. You value freedom and have a clear vision for your life, soaring above life's challenges with grace." },
          { "number": 4, "text": "Dolphin", "description": "You are playful and intelligent, with an innate ability to connect with others. Your social nature and empathy allow you to navigate the world with a gentle, yet persuasive charm." }
        ]
      }
      """

    user_prompt = "Quiz title: #{quiz_title}, Outcomes: #{outcomes}"

    %{"outcomes" => outcomes} =
      get_completion(@models[:gpt4], system_prompt, user_prompt,
        temperature: 0.8,
        response_format: %{type: "json_object"}
      )
      |> parse_chat()
      |> decode_json()

    {:ok, outcomes}
  end

  @doc """
  Generates a trivia question and adds it to a quiz
  """
  def generate_trivia_question(%{title: title} = quiz) do
    quiz = Repo.reload(quiz) |> Repo.preload(:questions)
    previous_questions = quiz.questions |> Enum.map(& &1.text) |> Enum.join(", ")

    system_prompt =
      """
        You are a quiz question generator that generates fun and interesting trivia questions"
        Each question on should have 4 possible answers, numbered 1-4.
        The questions should be of a difficulty level appropriate for an adult.
        Each question should have a brief explanation about the correct answer.
        I will give you the subject of the trivia and you will generate the data for a trivia quiz question on that topic.
        I will provide you with a list of previous questions so that you can avoid repeating them.
        Please generate the question in JSON format like the example below.
        Respond ONLY with the JSON with no additional text.

        User: "Subject: Interesting insects. Previous questions: What is the fastest insect?"

        You:

        {
          "text": "The praying mantid can move only the top part of this",
          "correct": 4,
          "explanation": "This ability allows them to sneak up on prey without startling it",
          "answers": [
            { "text": "arms", "number": 1 },
            { "text": "legs", "number": 2 },
            { "text": "eyes", "number": 3 },
            { "text": "body", "number": 4 }
          ]
        }
      """

    user_prompt = "Subject: #{title}. Previous questions: #{previous_questions}"

    get_completion(@models[:gpt4], system_prompt, user_prompt,
      temperature: 0.8,
      response_format: %{type: "json_object"}
    )
    |> parse_chat()
    |> decode_json()
  end

  @doc """
  Generates a set of category quiz questions
  """
  def generate_category_questions(quiz) do
    quiz = Repo.preload(quiz, :outcomes)

    system_prompt = """
    You are a quiz question generator that generates fun personaly quiz questions for 10-14 year olds.
    The quiz will attempt to categorize the taker in some way based on their responses.
    The quiz will have a certain number of possible outcomes (i.e. categories that the taker can be placed in).
    Each question should have a number of possible answers equal to the number of possible outcomes.
    The most frequently selected answer number will determine the outcome.
    Each question's answer `number` 1 will correspond to the outcome with `number` 1, and so on.
    The answers should be brief and easy for a 10-year old to understand.
    I will give you the title of the quiz, and the possible outcomes
    Please generate 5 questions JSON format like the example below.
    Respond ONLY with the valid JSON and no additional text.

    User: "Title: What kind of superhero are you? Outcomes: 1) Captain America, 2) Black Panther, 3) Iron Man, 4) Thor"

    You:

    {
      "questions": [
        {
          "text": "How do you like to spend your free time?",
          "answers": [
            { "text": "Helping others", "number": 1 },
            { "text": "Studying or reading", "number": 2 },
            { "text": "Inventing or building things", "number": 3 },
            { "text": "Exploring the outdoors", "number": 4 }
          ]
        }
      ]
      // 4 more questions...
    }
    """

    outcomes = quiz.outcomes |> Enum.map(&"#{&1.number}) #{&1.text}") |> Enum.join(", ")
    user_prompt = "Title: #{quiz.title}. Outcomes: #{outcomes}"

    %{"questions" => questions} =
      get_completion(@models[:gpt4], system_prompt, user_prompt,
        temperature: 0.8,
        response_format: %{type: "json_object"}
      )
      |> parse_chat()
      |> decode_json()

    {:ok, questions}
  end

  @doc """
  Generates an prompt to create a cover image for a quiz or outcome
  """
  def generate_image_prompt(quiz_title) when is_binary(quiz_title) do
    system_prompt = """
    You are a an image prompt generator that generates prompts to create cover images for quizzes.
    I will give you the title of the quiz and you will generate a prompt for a cover image for that quiz.
    The prompt should ALWAYS specify a 'fantasy illustration' style, and also specify that the image should contain NO TEXT.
    Do not give any additional explantion, just the prompt text that can be passed to the DALL-E model.
    """

    user_prompt = "Title: #{quiz_title}"

    get_completion(@models[:gpt4], system_prompt, user_prompt, temperature: 0.8)
    |> parse_chat()
  end

  def generate_image_prompt(%Quiz{} = quiz) do
    generate_image_prompt(quiz.title)
  end

  def generate_image_prompt(%Outcome{} = outcome) do
    outcome = Repo.preload(outcome, :quiz)

    system_prompt = ""

    user_prompt =
      """
      Please write a Stable Diffusion prompt to generate an image to when a user completes
      the personality quiz: "#{outcome.quiz.title}" and gets the outcome: #{outcome.text}.
      The image should be entertaining for a 10-year-old child.
      Try to make it funny, surprising, or ironic.
      Provide only the prompt text that can be passed to Stable Diffusion with no additional explanation.
      """

    get_completion(@models[:gpt4], system_prompt, user_prompt, temperature: 0.8)
    |> parse_chat()
  end

  @doc """
  Generates an image for a quiz, and saves it to the filesystem
  Returns a 3-item :ok tuple with the filename and prompt used to generate the image.
  """
  def generate_image(%Quiz{} = quiz) do
    {:ok, prompt} = generate_image_prompt(quiz)

    # generate image
    {:ok, %{data: [%{"url" => url}]}} =
      OpenAI.image_generations(prompt: prompt, size: "512x512") |> IO.inspect()

    filename = download_image(url)

    {:ok, filename, prompt}
  end

  @doc """
  Temporary function to generate and download test image from a prompt
  """
  def generate_image_from_prompt(prompt) do
    {:ok, %{data: [%{"url" => url}]}} =
      OpenAI.image_generations(prompt: prompt, size: "512x512") |> IO.inspect()

    filename = download_image(url)

    {:ok, filename}
  end

  defp download_image(url) do
    download_path = Application.get_env(:quiz, :download_path)

    # parse file name
    [filename] = Regex.run(~r/img-.*\.png/, url)

    # download image
    %Req.Response{status: 200, body: body} = Req.get!(url)
    File.write!("#{download_path}/#{filename}", body)

    filename
  end

  defp get_completion(model, system_prompt, user_prompt, options) do
    messages = [
      %{role: "system", content: system_prompt},
      %{role: "user", content: user_prompt}
    ]

    args = Keyword.merge([model: model, messages: messages], options)

    OpenAI.chat_completion(args)
  end

  defp parse_chat({:ok, %{choices: [%{"message" => %{"content" => content}} | _]}}),
    do: {:ok, content}

  defp parse_chat({:error, %{"error" => %{"message" => message}}}), do: {:error, message}

  defp decode_json({:ok, json}) do
    Jason.decode!(json)
  end

  # defp create_quiz_changeset(attrs) do
  #   Quiz.changeset(%Quiz{}, attrs)
  # end
end
