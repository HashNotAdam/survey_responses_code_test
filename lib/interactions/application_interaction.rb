# frozen_string_literal: true

require "active_interaction"
require "interactions/log/error"

class ApplicationInteraction < ActiveInteraction::Base
  def execute
    raise "You need to create an execute method on your interaction"
  end

  def run!
    super
  rescue ActiveInteraction::InvalidInteractionError => e
    error(e.message)
  end

  def error(message)
    Log::Error.run!(message: <<~MESSAGE)
      Error: #{message}
      Usage: bin/survey-tool data_path responses_path
    MESSAGE

    exit(1)
  end
end
