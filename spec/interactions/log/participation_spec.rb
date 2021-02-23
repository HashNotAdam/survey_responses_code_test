# frozen_string_literal: true

require "interactions/log/participation"

RSpec.describe Log::Participation do
  let(:responses) do
    [
      {
        submitted: true,
        answers: {
          "Rating question 1" => "5",
          "Rating question 2" => "5",
          "Not a rating question" => "Answer 1",
        },
      },
      {
        submitted: true,
        answers: {
          "Rating question 1" => "4",
          "Rating question 2" => "3",
          "Not a rating question" => "Answer 2",
        },
      },
      { submitted: false },
    ]
  end
  let(:expected_output) do
    <<~OUTPUT
      Participation
      -------------
      2 participants
      66.7% participation

    OUTPUT
  end

  it "logges the participation for the survey" do
    expect { described_class.run!(responses: responses) }.
      to output(expected_output).
      to_stdout_from_any_process
  end
end
