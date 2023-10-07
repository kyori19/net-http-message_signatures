# frozen_string_literal: true

RSpec.describe Net::HTTP::MessageSignatures do
  it 'has a version number' do
    expect(Net::HTTP::MessageSignatures::VERSION).not_to be_nil
  end
end
