# frozen_string_literal: true

require "interactions/parse/questions"
require "interactions/parse/responses"
require "interactions/log/participation"
require "interactions/log/rating_question_averages"

class Application
  def cli
    Process.setproctitle("Culture Amp Survey Response Parser")

    questions = Parse::Questions.run!(data_path: ARGV[0])
    responses = Parse::Responses.
      run!(questions: questions, responses_path: ARGV[1])
    Log::Participation.run!(responses: responses)
    Log::RatingQuestionAverages.run!(questions: questions, responses: responses)
  end
end
