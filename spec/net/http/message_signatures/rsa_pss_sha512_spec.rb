# frozen_string_literal: true

require 'base64'

require 'net/http/message_signatures/rsa_pss_sha512'

RSpec.describe Net::HTTP::MessageSignatures::RSAPSSSHA512 do
  subject(:algorithm) { described_class.new key: }

  context 'with RSAPSS-SHA512 key' do
    let(:key) { OpenSSL::PKey::RSA.new(File.open(File.join(__dir__, 'keys', 'test-key-rsa-pss.pem'))) }

    describe '#sign and #verify' do
      it 'signs and verifies input' do
        signature = algorithm.sign('input')
        expect(algorithm.verify('input', signature)).to be_truthy
      end
    end
  end

  context 'with DSA key' do
    let(:key) { OpenSSL::PKey::DSA.generate(1024) }

    describe '#sign' do
      it 'raises InvalidAlgorithm' do
        expect { algorithm.sign('input') }
          .to raise_error Net::HTTP::MessageSignatures::SignatureAlgorithm::InvalidAlgorithm
      end
    end

    describe '#verify' do
      it 'raises InvalidAlgorithm' do
        expect { algorithm.verify('input', 'signature') }
          .to raise_error Net::HTTP::MessageSignatures::SignatureAlgorithm::InvalidAlgorithm
      end
    end
  end
end
