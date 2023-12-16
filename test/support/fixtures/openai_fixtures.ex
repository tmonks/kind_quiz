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
end
