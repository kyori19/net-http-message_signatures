# frozen_string_literal: true

require 'net/http/structured_field_values'

require 'net/http/message_signatures/rsa_pss_sha512'
require 'net/http/message_signatures/signature'

RSpec.describe Net::HTTP::MessageSignatures::Signature do
  sfv = Net::HTTP::StructuredFieldValues

  context 'with rsa-pss-sha512 (test-key-rsa-pss)' do
    let(:algorithm) do
      key = OpenSSL::PKey::RSA.new(File.open(File.join(__dir__, 'keys', 'test-key-rsa-pss.pem')))
      Net::HTTP::MessageSignatures::RSAPSSSHA512.new(key:)
    end

    # @see {https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-message-signatures-19#appendix-B.2.1}
    context 'with Minimal Signature Using rsa-pss-sha512' do
      describe '#verify!' do
        it 'raises nothing' do
          signature = described_class.new(
            signature: sfv::Parser.parse_as_item(<<~SIGN.strip).value,
              :d2pmTvmbncD3xQm8E9ZV2828BjQWGgiwAaw5bAkgibUopem\
              LJcWDy/lkbbHAve4cRAtx31Iq786U7it++wgGxbtRxf8Udx7zFZsckzXaJMkA7ChG\
              52eSkFxykJeNqsrWH5S+oxNFlD4dzVuwe8DhTSja8xxbR/Z2cOGdCbzR72rgFWhzx\
              2VjBqJzsPLMIQKhO4DGezXehhWwE56YCE+O6c0mKZsfxVrogUvA4HELjVKWmAvtl6\
              UnCh8jYzuVG5WSb/QEVPnP5TmcAnLH1g+s++v6d4s8m0gCw1fV5/SITLq9mhho8K3\
              +7EPYTU8IU1bLhdxO5Nyt8C8ssinQ98Xw9Q==:
            SIGN
            covered_components: {},
            params: {
              'created' => 1618884473,
              'keyid' => 'test-key-rsa-pss',
              'nonce' => 'b3k2pp5k7z-50gnwp.yemd',
            },
            algorithm:,
          )

          expect { signature.verify! }.not_to raise_error
        end
      end
    end

    # @see {https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-message-signatures-19#appendix-B.2.2}
    context 'with Selective Covered Components using rsa-pss-sha512' do
      describe '#verify!' do
        it 'raises nothing' do
          signature = described_class.new(
            signature: sfv::Parser.parse_as_item(<<~SIGN.strip).value,
              :LjbtqUbfmvjj5C5kr1Ugj4PmLYvx9wVjZvD9GsTT4F7GrcQ\
              EdJzgI9qHxICagShLRiLMlAJjtq6N4CDfKtjvuJyE5qH7KT8UCMkSowOB4+ECxCmT\
              8rtAmj/0PIXxi0A0nxKyB09RNrCQibbUjsLS/2YyFYXEu4TRJQzRw1rLEuEfY17SA\
              RYhpTlaqwZVtR8NV7+4UKkjqpcAoFqWFQh62s7Cl+H2fjBSpqfZUJcsIk4N6wiKYd\
              4je2U/lankenQ99PZfB4jY3I5rSV2DSBVkSFsURIjYErOs0tFTQosMTAoxk//0RoK\
              UqiYY8Bh0aaUEb0rQl3/XaVe4bXTugEjHSw==:
            SIGN
            covered_components: {
              '@authority' => 'example.com',
              'content-digest' =>
                'sha-512=:WZDPaVn/7XgHaAy8pmojAkGWoRx2UFChF41A2svX+TaPm+AbwAgBWnrIiYllu7BNNyealdVLvRwEmTHWXvJwew==:',
              sfv::ParameterizedValue.new('@query-param', { 'name' => 'Pet' }) => 'dog',
            },
            params: {
              'created' => 1618884473,
              'keyid' => 'test-key-rsa-pss',
              'tag' => 'header-example',
            },
            algorithm:,
          )

          expect { signature.verify! }.not_to raise_error
        end
      end
    end

    # @see {https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-message-signatures-19#appendix-B.2.3}
    context 'with Full Coverage using rsa-pss-sha512' do
      describe '#verify!' do
        it 'raises nothing' do
          signature = described_class.new(
            signature: sfv::Parser.parse_as_item(<<~SIGN.strip).value,
              :bbN8oArOxYoyylQQUU6QYwrTuaxLwjAC9fbY2F6SVWvh0yB\
              iMIRGOnMYwZ/5MR6fb0Kh1rIRASVxFkeGt683+qRpRRU5p2voTp768ZrCUb38K0fU\
              xN0O0iC59DzYx8DFll5GmydPxSmme9v6ULbMFkl+V5B1TP/yPViV7KsLNmvKiLJH1\
              pFkh/aYA2HXXZzNBXmIkoQoLd7YfW91kE9o/CCoC1xMy7JA1ipwvKvfrs65ldmlu9\
              bpG6A9BmzhuzF8Eim5f8ui9eH8LZH896+QIF61ka39VBrohr9iyMUJpvRX2Zbhl5Z\
              JzSRxpJyoEZAFL2FUo5fTIztsDZKEgM4cUA==:
            SIGN
            covered_components: {
              'date' => 'Tue, 20 Apr 2021 02:07:55 GMT',
              '@method' => 'POST',
              '@path' => '/foo',
              '@query' => '?param=Value&Pet=dog',
              '@authority' => 'example.com',
              'content-type' => 'application/json',
              'content-digest' =>
                'sha-512=:WZDPaVn/7XgHaAy8pmojAkGWoRx2UFChF41A2svX+TaPm+AbwAgBWnrIiYllu7BNNyealdVLvRwEmTHWXvJwew==:',
              'content-length' => '18',
            },
            params: {
              'created' => 1618884473,
              'keyid' => 'test-key-rsa-pss',
            },
            algorithm:,
          )

          expect { signature.verify! }.not_to raise_error
        end
      end
    end

    context 'when signature is invalid' do
      describe '#verify!' do
        it 'raises VerificationError' do
          signature = described_class.new(
            signature: sfv::Parser.parse_as_item(<<~SIGN.strip).value,
              :pmpmTvmbncD3xQm8E9ZV2828BjQWGgiwAaw5bAkgibUopem\
              LJcWDy/lkbbHAve4cRAtx31Iq786U7it++wgGxbtRxf8Udx7zFZsckzXaJMkA7ChG\
              52eSkFxykJeNqsrWH5S+oxNFlD4dzVuwe8DhTSja8xxbR/Z2cOGdCbzR72rgFWhzx\
              2VjBqJzsPLMIQKhO4DGezXehhWwE56YCE+O6c0mKZsfxVrogUvA4HELjVKWmAvtl6\
              UnCh8jYzuVG5WSb/QEVPnP5TmcAnLH1g+s++v6d4s8m0gCw1fV5/SITLq9mhho8K3\
              +7EPYTU8IU1bLhdxO5Nyt8C8ssinQ98Xw9Q==:
            SIGN
            covered_components: {},
            params: {
              'created' => 1618884473,
              'keyid' => 'test-key-rsa-pss',
              'nonce' => 'b3k2pp5k7z-50gnwp.yemd',
            },
            algorithm:,
          )

          expect { signature.verify! }.to raise_error described_class::VerificationError
        end
      end
    end
  end
end
