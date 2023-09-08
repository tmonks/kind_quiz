ExUnit.start()

# set quiz to the fixture
Application.put_env(:quiz, :quiz_path, Path.expand("../test/support/fixtures/quiz.csv", __DIR__))
