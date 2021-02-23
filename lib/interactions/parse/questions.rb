# frozen_string_literal: true

require "csv"
require "interactions/application_interaction"

module Parse
  class Questions < ApplicationInteraction
    string :data_path, default: nil

    def execute
      validate
      questions_hashes
    end

    private

    def validate
      if data_path.nil?
        error("A survey data CSV file path is required")
      end

      unless File.exist?(data_path)
        error("Data file does not exist (#{data_path})")
      end
    end

    def questions_hashes
      CSV.parse(File.read(data_path), headers: true).map(&:to_h)
    end
  end
end
