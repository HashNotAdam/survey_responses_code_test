# frozen_string_literal: true

require "interactions/parse/questions"

RSpec.describe Parse::Questions do
  let(:data_path) { "example-data/survey-1.csv" }
  let(:expected_result) do
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

  it "returns an array of question hashes" do
    result = described_class.run!(data_path: data_path)
    expect(result).to contain_exactly(*expected_result)
  end

  context "when the data file does not exist" do
    it "raises an error" do
      expect { described_class.run!(data_path: "invalid.file") }.
        to output(
          a_string_including("Error: Data file does not exist (abc.def)")
        ).to_stderr_from_any_process
    end
  end
end
