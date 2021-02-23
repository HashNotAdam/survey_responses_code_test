# frozen_string_literal: true

require "interactions/application_interaction"
require "interactions/log/info"

module Log
  class RatingQuestionAverages < ApplicationInteraction
    array :questions do
      hash do
        string :theme
        string :type
        string :text
      end
    end
    array :responses do
      hash do
        boolean :submitted
        hash :answers, default: nil, strip: false
      end
    end

    def execute
      return if presented_average_ratings.empty?

      Info.run!(message: <<~MESSAGE)
        Average ratings
        ---------------
        #{presented_average_ratings}
      MESSAGE
    end

    private

    def presented_average_ratings
      @presented_average_ratings ||= begin
        presented_ratings = average_ratings.map do |(question, average_rating)|
          <<~OUTPUT
            #{question}
              #{format("%.1f", average_rating)}
          OUTPUT
        end
        presented_ratings.join("\n").strip
      end
    end

    def average_ratings
      rating_questions.each_with_object({}) do |question, ratings|
        average_rating = average_rating_for(question)
        next if average_rating.nil?

        ratings[question] = average_rating
      end
    end

    def rating_questions
      questions.select { _1["type"] == "ratingquestion" }.map { _1["text"] }
    end

    def average_rating_for(question)
      answers = submitted_responses.map { integer_answer(_1, question) }.compact
      return if answers.empty?

      answers.sum.to_f / answers.count
    end

    def submitted_responses
      responses.select { _1[:submitted] == true }
    end

    def integer_answer(response, question)
      response[:answers][question].to_i
    end
  end
end
