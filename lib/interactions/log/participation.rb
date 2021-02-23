# frozen_string_literal: true

require "interactions/application_interaction"
require "interactions/log/info"

module Log
  class Participation < ApplicationInteraction
    array :responses do
      hash do
        boolean :submitted
        hash :answers, default: nil
      end
    end

    def execute
      Info.run!(message: <<~MESSAGE)
        Participation
        -------------
        #{total_participants} participants
        #{particiation_percent}% participation

      MESSAGE
    end

    private

    def total_participants
      submitted_responses.count
    end

    def submitted_responses
      responses.select { _1[:submitted] }
    end

    def particiation_percent
      percent = particiation_rate * 100
      format("%.1f", percent)
    end

    def particiation_rate
      total_participants / responses.count.to_f
    end
  end
end
