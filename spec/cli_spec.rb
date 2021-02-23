# frozen_string_literal: true

# rubocop:disable RSpec/DescribeClass
RSpec.describe "Command line interface", type: :cli do
  let(:bin_file) { "bin/survey-tool" }

  it "prints the participation count and percentage of the survey" do
    data_file = "example-data/survey-1.csv"
    response_file = "example-data/survey-1-responses.csv"
    expected_output = <<~OUTPUT
      Participation
      -------------
      5 participants
      83.3% participation
    OUTPUT

    expect { system("#{bin_file} #{data_file} #{response_file}") }.
      to output(a_string_including(expected_output)).
      to_stdout_from_any_process
  end

  it "prints the average response of each rating question" do
    data_file = "example-data/survey-2.csv"
    response_file = "example-data/survey-2-responses.csv"
    expected_output = <<~OUTPUT
      Average ratings
      ---------------
      I like the kind of work I do.
        4.6

      In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.
        5.0

      We are working at the right pace to meet our goals.
        5.0

      I feel empowered to get the work done for which I am responsible.
        3.6
    OUTPUT

    expect { system("#{bin_file} #{data_file} #{response_file}") }.
      to output(a_string_including(expected_output)).
      to_stdout_from_any_process
  end

  context "when there are unsubmitted responses" do
    it "does not include the nil values in the average calculation" do
      data_file = "example-data/survey-1.csv"
      response_file = "example-data/survey-1-responses.csv"
      expected_output = <<~OUTPUT
        Average ratings
        ---------------
        I like the kind of work I do.
          4.6

        In general, I have the resources (e.g., business tools, information, facilities, IT or functional support) I need to be effective.
          5.0

        We are working at the right pace to meet our goals.
          5.0

        I feel empowered to get the work done for which I am responsible.
          3.6

        I am appropriately involved in decisions that affect my work.
          3.6
      OUTPUT

      expect { system("#{bin_file} #{data_file} #{response_file}") }.
        to output(a_string_including(expected_output)).
        to_stdout_from_any_process
    end
  end

  context "when there are no submitted responses" do
    it "does not print the average ratings" do
      data_file = "example-data/survey-3.csv"
      response_file = "example-data/survey-3-responses.csv"
      expect { system("#{bin_file} #{data_file} #{response_file}") }.
        not_to output(a_string_including("Average ratings")).
        to_stdout_from_any_process
    end
  end

  context "when a survey data file is not supplied" do
    it "prints an error" do
      expect { system("bin/survey-tool") }.
        to output(a_string_matching(/^Error:.+data CSV file path/)).
        to_stderr_from_any_process
    end
  end

  context "when a survey reponse file is not supplied" do
    it "prints an error" do
      data_file = "example-data/survey-1.csv"
      expect { system("bin/survey-tool #{data_file}") }.
        to output(a_string_matching(/^Error:.+responses CSV file path/)).
        to_stderr_from_any_process
    end
  end
end
# rubocop:enable RSpec/DescribeClass
