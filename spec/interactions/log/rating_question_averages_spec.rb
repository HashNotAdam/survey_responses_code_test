# frozen_string_literal: true

require "interactions/log/rating_question_averages"

RSpec.describe Log::RatingQuestionAverages do
  let(:questions) do
    [
      {
        "theme" => "The Work",
        "type" => "ratingquestion",
        "text" => "Rating question 1",
      },
      {
        "theme" => "The Work",
        "type" => "ratingquestion",
        "text" => "Rating question 2",
      },
      {
        "theme" => "The Place",
        "type" => "singleselect",
        "text" => "Not a rating question",
      },
    ]
  end
  let(:responses) do
    [
      {
        submitted: true,
        answers: {
          questions[0]["text"] => "5",
          questions[1]["text"] => "5",
          questions[2]["text"] => "Answer 1",
        },
      },
      {
        submitted: true,
        answers: {
          questions[0]["text"] => "4",
          questions[1]["text"] => "3",
          questions[2]["text"] => "Answer 2",
        },
      },
      { submitted: false },
    ]
  end
  let(:expected_output) do
    <<~OUTPUT
      Average ratings
      ---------------
      Rating question 1
        4.5

      Rating question 2
        4.0
    OUTPUT
  end

  it "logs the average response to each rating question" do
    expect { described_class.run!(questions: questions, responses: responses) }.
      to output(expected_output).
      to_stdout_from_any_process
  end
end
