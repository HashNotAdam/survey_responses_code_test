# frozen_string_literal: true

require "csv"
require "interactions/application_interaction"

module Parse
  class Responses < ApplicationInteraction
    array :questions do
      hash do
        string :theme
        string :type
        string :text
      end
    end
    string :responses_path, default: nil

    def execute
      validate
      responses_hashes
    end

    private

    def validate
      if responses_path.nil?
        return error("A responses CSV file path is required")
      end

      unless File.exist?(responses_path)
        error("Responses file does not exist (#{responses_path})")
      end
    end

    def responses_hashes
      responses = []

      CSV.foreach(responses_path) do |response|
        responses << response_hash(response)
      end

      responses
    end

    COLUMNS = %i[email employee_id submitted_at].freeze
    private_constant :COLUMNS

    def response_hash(response)
      return { submitted: false } unless submitted_response?(response)

      first_answer_index = COLUMNS.length
      questions.each_with_object({ submitted: true, answers: {} }).
        with_index(first_answer_index) do |(question, hash), index|
          hash[:answers][question["text"]] = presence(response[index])
        end
    end

    def submitted_response?(response)
      submitted_at = response[COLUMNS.index(:submitted_at)]
      !presence(submitted_at).nil?
    end

    def presence(value)
      value unless value&.empty?
    end
  end
end
