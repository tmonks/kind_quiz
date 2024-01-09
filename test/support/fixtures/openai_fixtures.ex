defmodule KQ.Fixtures.OpenAI do
  def chat_response_category_quiz do
    %{
      id: "chatcmpl-8bs4ZU6eRVyt09VF26oN9dVTohmjL",
      usage: %{
        "completion_tokens" => 617,
        "prompt_tokens" => 480,
        "total_tokens" => 1097
      },
      created: 1_704_036_683,
      object: "chat.completion",
      model: "gpt-4-1106-preview",
      choices: [
        %{
          "finish_reason" => "stop",
          "index" => 0,
          "logprobs" => nil,
          "message" => %{
            "content" =>
              "{\n  \"title\": \"What kind of pizza are you?\",\n  \"type\": \"category\",\n  \"outcomes\": [\n    { \"number\": 1, \"text\": \"Cheese Pizza\" },\n    { \"number\": 2, \"text\": \"Pepperoni Pizza\" },\n    { \"number\": 3, \"text\": \"Veggie Pizza\" },\n    { \"number\": 4, \"text\": \"Hawaiian Pizza\" },\n    { \"number\": 5, \"text\": \"Meat Lovers Pizza\" }\n  ],\n  \"questions\": [\n    {\n      \"text\": \"What's your favorite school subject?\",\n      \"answers\": [\n        { \"text\": \"Art\", \"number\": 1 },\n        { \"text\": \"Gym\", \"number\": 2 },\n        { \"text\": \"Science\", \"number\": 3 },\n        { \"text\": \"Music\", \"number\": 4 },\n        { \"text\": \"Lunch!\", \"number\": 5 }\n      ]\n    },\n    {\n      \"text\": \"Pick a weekend activity:\",\n      \"answers\": [\n        { \"text\": \"Drawing or painting\", \"number\": 1 },\n        { \"text\": \"Playing video games\", \"number\": 2 },\n        { \"text\": \"Gardening or hiking\", \"number\": 3 },\n        { \"text\": \"Going to the beach\", \"number\": 4 },\n        { \"text\": \"Playing sports\", \"number\": 5 }\n      ]\n    },\n    {\n      \"text\": \"Choose a pet:\",\n      \"answers\": [\n        { \"text\": \"Fish\", \"number\": 1 },\n        { \"text\": \"Dog\", \"number\": 2 },\n        { \"text\": \"Cat\", \"number\": 3 },\n        { \"text\": \"Parrot\", \"number\": 4 },\n        { \"text\": \"Hamster\", \"number\": 5 }\n      ]\n    },\n    {\n      \"text\": \"What is your dream vacation?\",\n      \"answers\": [\n        { \"text\": \"Art museum tour\", \"number\": 1 },\n        { \"text\": \"Amusement park adventure\", \"number\": 2 },\n        { \"text\": \"Nature camp\", \"number\": 3 },\n        { \"text\": \"Tropical island\", \"number\": 4 },\n        { \"text\": \"Big city exploration\", \"number\": 5 }\n      ]\n    },\n    {\n      \"text\": \"Pick a superpower:\",\n      \"answers\": [\n        { \"text\": \"Invisibility\", \"number\": 1 },\n        { \"text\": \"Super speed\", \"number\": 2 },\n        { \"text\": \"Talking to animals\", \"number\": 3 },\n        { \"text\": \"Flying\", \"number\": 4 },\n        { \"text\": \"Super strength\", \"number\": 5 }\n      ]\n    }\n  ]\n}",
            "role" => "assistant"
          }
        }
      ],
      system_fingerprint: "fp_3905aa4f79"
    }
    |> Jason.encode!()
  end

  def image_generation_error do
    {:error,
     %{
       "error" => %{
         "code" => nil,
         "message" =>
           "The server had an error while processing your request. Sorry about that! You can retry your request, or contact us through our help center at help.openai.com if the error persists. (Please include the request ID 1324e5f118f18d23824e0d62894e96b4 in your message.)",
         "param" => nil,
         "type" => "server_error"
       }
     }}
  end

  def chat_response_image_prompt(expected_text \\ "Some image prompt") do
    %{
      id: "chatcmpl-8WVzE1LU67FXluVAn9dMSre0KncVE",
      usage: %{
        "completion_tokens" => 67,
        "prompt_tokens" => 110,
        "total_tokens" => 177
      },
      created: 1_702_760_144,
      object: "chat.completion",
      model: "gpt-4-1106-preview",
      choices: [
        %{
          "finish_reason" => "stop",
          "index" => 0,
          "logprobs" => nil,
          "message" => %{
            "content" => expected_text,
            "role" => "assistant"
          }
        }
      ],
      system_fingerprint: "fp_3905aa4f79"
    }
    |> Jason.encode!()
  end

  def chat_response_outcomes do
    %{
      id: "chatcmpl-8WU0mjU3asNwQUB98wik9io3Hyx2P",
      usage: %{
        "completion_tokens" => 222,
        "prompt_tokens" => 331,
        "total_tokens" => 553
      },
      created: 1_702_752_552,
      object: "chat.completion",
      model: "gpt-4-1106-preview",
      choices: [
        %{
          "finish_reason" => "stop",
          "index" => 0,
          "logprobs" => nil,
          "message" => %{
            "content" =>
              "{\n  \"outcomes\": [\n    { \"number\": 1, \"text\": \"Wolf\", \"description\": \"You're a natural-born leader with a strong sense of loyalty and a desire for freedom. You value deep connections with others and are not afraid to face challenges head-on.\" },\n    { \"number\": 2, \"text\": \"Bear\", \"description\": \"You exude confidence and strength, preferring solitude or a small circle of close friends. Your resilience and protective nature make you a powerful presence to those around you.\" },\n    { \"number\": 3, \"text\": \"Eagle\", \"description\": \"Your perspective is unique, offering you insight that others may lack. You value freedom and have a clear vision for your life, soaring above life's challenges with grace.\" },\n    { \"number\": 4, \"text\": \"Dolphin\", \"description\": \"You are playful and intelligent, with an innate ability to connect with others. Your social nature and empathy allow you to navigate the world with a gentle, yet persuasive charm.\" }\n  ]\n}",
            "role" => "assistant"
          }
        }
      ],
      system_fingerprint: "fp_3905aa4f79"
    }
    |> Jason.encode!()
  end

  def chat_response_category_questions do
    %{
      id: "chatcmpl-8b8t5bO6e0M5B4mryLoTAINRW2Mg5",
      usage: %{
        "completion_tokens" => 528,
        "prompt_tokens" => 386,
        "total_tokens" => 914
      },
      created: 1_703_862_991,
      object: "chat.completion",
      model: "gpt-4-1106-preview",
      choices: [
        %{
          "finish_reason" => "stop",
          "index" => 0,
          "logprobs" => nil,
          "message" => %{
            "content" =>
              "{\n  \"questions\": [\n    {\n      \"text\": \"Pick a hobby you love doing:\",\n      \"answers\": [\n        { \"text\": \"Playing video games\", \"number\": 1 },\n        { \"text\": \"Hiking in nature\", \"number\": 2 },\n        { \"text\": \"Crafting or drawing\", \"number\": 3 },\n        { \"text\": \"Playing sports\", \"number\": 4 },\n        { \"text\": \"Reading mystery books\", \"number\": 5 }\n      ]\n    },\n    {\n      \"text\": \"What's your favorite time of the day?\",\n      \"answers\": [\n        { \"text\": \"Afternoon snack time\", \"number\": 1 },\n        { \"text\": \"Early morning\", \"number\": 2 },\n        { \"text\": \"Lunch break\", \"number\": 3 },\n        { \"text\": \"Evening workout\", \"number\": 4 },\n        { \"text\": \"Bedtime\", \"number\": 5 }\n      ]\n    },\n    {\n      \"text\": \"Choose an animal that best represents you:\",\n      \"answers\": [\n        { \"text\": \"Playful puppy\", \"number\": 1 },\n        { \"text\": \"Wise owl\", \"number\": 2 },\n        { \"text\": \"Graceful swan\", \"number\": 3 },\n        { \"text\": \"Energetic kangaroo\", \"number\": 4 },\n        { \"text\": \"Curious cat\", \"number\": 5 }\n      ]\n    },\n    {\n      \"text\": \"If you were a superhero, what would be your power?\",\n      \"answers\": [\n        { \"text\": \"Super strength\", \"number\": 1 },\n        { \"text\": \"Time travel\", \"number\": 2 },\n        { \"text\": \"Invisibility\", \"number\": 3 },\n        { \"text\": \"Flying\", \"number\": 4 },\n        { \"text\": \"Mind reading\", \"number\": 5 }\n      ]\n    },\n    {\n      \"text\": \"What's your dream vacation destination?\",\n      \"answers\": [\n        { \"text\": \"Amusement park\", \"number\": 1 },\n        { \"text\": \"Mountain cabin\", \"number\": 2 },\n        { \"text\": \"Artistic city\", \"number\": 3 },\n        { \"text\": \"Tropical beach\", \"number\": 4 },\n        { \"text\": \"Historical site\", \"number\": 5 }\n      ]\n    }\n  ]\n}",
            "role" => "assistant"
          }
        }
      ],
      system_fingerprint: "fp_3905aa4f79"
    }
    |> Jason.encode!()
  end

  def expect_chat_request(bypass, response) do
    Bypass.expect_once(bypass, "POST", "/v1/chat/completions", fn conn ->
      Plug.Conn.resp(conn, 200, response)
    end)
  end
end
