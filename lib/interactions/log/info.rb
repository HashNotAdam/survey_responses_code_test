# frozen_string_literal: true

module Log
  class Info
    def self.run!(message:)
      $stdout.write(message)
    end
  end
end
