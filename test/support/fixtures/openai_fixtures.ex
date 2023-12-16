defmodule KQ.Fixtures.OpenAI do
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

  def chat_response_image_prompt do
    {:ok,
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
             "content" =>
               "Fantasy illustration of an enchanted Thanksgiving feast table with a variety of mystical side dishes, such as a bowl of glowing cranberry sauce, a levitating sweet potato casserole with twinkling marshmallows, and a pie with a magical aura, all set in an autumnal forest clearing surrounded by mythical creatures, with no text.",
             "role" => "assistant"
           }
         }
       ],
       system_fingerprint: "fp_3905aa4f79"
     }}
  end

  def chat_response_outcomes do
    {:ok,
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
     }}
  end
end
