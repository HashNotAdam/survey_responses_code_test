# frozen_string_literal: true

require "interactions/log/error"

RSpec.describe Log::Error do
  it "writes to standard error" do
    expect { described_class.run!(message: "Foobar") }.
      to output("Foobar").
      to_stderr_from_any_process
  end
end
