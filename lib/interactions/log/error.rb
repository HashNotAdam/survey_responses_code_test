# frozen_string_literal: true

module Log
  class Error
    def self.run!(message:)
      $stderr.write(message)
    end
  end
end
