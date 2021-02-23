# frozen_string_literal: true

require "interactions/log/info"

RSpec.describe Log::Info do
  it "writes to standard out" do
    expect { described_class.run!(message: "Foobar") }.
      to output("Foobar").
      to_stdout_from_any_process
  end
end
