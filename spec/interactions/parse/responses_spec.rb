# frozen_string_literal: true

require "interactions/parse/responses"

RSpec.describe Parse::Responses do
  let(:responses_path) { "example-data/survey-1-responses.csv" }
  let(:questions) do
    [
      {
        "theme" => "The Work",
        "type" => "ratingquestion",
        "text" => "I like the kind of work I do.",
      },
      {
        "theme" => "The Work",
        "type" => "ratingquestion",
        "text" => "We are working at the right pace to meet our goals.",
      },
      {
        "theme" => "The Work",
        "type" => "ratingquestion",
        "text" => "In general, I have the resources (e.g., business tools, " \
                  "information, facilities, IT or functional support) I need " \
                  "to be effective.",
      },
      {
        "theme" => "The Place",
        "type" => "ratingquestion",
        "text" => "I feel empowered to get the work done for which I am " \
                  "responsible.",
      },
      {
        "theme" => "The Place",
        "type" => "ratingquestion",
        "text" => "I am appropriately involved in decisions that affect my " \
                  "work.",
      },
    ]
  end
  let(:expected_result) do
    [
      {
        submitted: true,
        answers: {
          questions[0]["text"] => "5",
          questions[1]["text"] => "5",
          questions[2]["text"] => "5",
          questions[3]["text"] => "4",
          questions[4]["text"] => "4",
        },
      },
      {
        submitted: true,
        answers: {
          questions[0]["text"] => "4",
          questions[1]["text"] => "5",
          questions[2]["text"] => "5",
          questions[3]["text"] => "3",
          questions[4]["text"] => "3",
        },
      },
      {
        submitted: true,
        answers: {
          questions[0]["text"] => "5",
          questions[1]["text"] => "5",
          questions[2]["text"] => "5",
          questions[3]["text"] => "5",
          questions[4]["text"] => "4",
        },
      },
      {
        submitted: true,
        answers: {
          questions[0]["text"] => "5",
          questions[1]["text"] => "5",
          questions[2]["text"] => "5",
          questions[3]["text"] => "4",
          questions[4]["text"] => "4",
        },
      },
      {
        submitted: true,
        answers: {
          questions[0]["text"] => "4",
          questions[1]["text"] => "5",
          questions[2]["text"] => "5",
          questions[3]["text"] => "2",
          questions[4]["text"] => "3",
        },
      },
      { submitted: false },
    ]
  end

  it "returns an array of responses hashes" do
    result = described_class.
      run!(questions: questions, responses_path: responses_path)
    expect(result).to contain_exactly(*expected_result)
  end

  context "when the data file does not exist" do
    it "raises an error" do
      expect do
        described_class.
          run!(questions: questions, responses_path: "invalid.file")
      end.
        to output(
          a_string_including("Error: Data file does not exist (abc.def)")
        ).to_stderr_from_any_process
    end
  end
end
