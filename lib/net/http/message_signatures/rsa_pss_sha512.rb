# frozen_string_literal: true

require 'net/http'
require 'openssl'

require 'net/http/message_signatures/signature_algorithm'

module Net
  class HTTP
    module MessageSignatures
      # Implementation of the signature algorithm, RSASSA-PSS using SHA-512.
      #
      # @see {https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-message-signatures-19#section-3.3.1}
      class RSAPSSSHA512 < SignatureAlgorithm
        # @return [OpenSSL::PKey::RSA] key material
        attr_writer :key

        # @param [OpenSSL::PKey::RSA] key key material
        def initialize(key: nil)
          super()
          @key = key
        end

        def verify(message, signature)
          ensure_key!
          key.verify_pss('SHA512', signature, message, salt_length: 64, mgf1_hash: 'SHA512')
        end

        private

        # @return [OpenSSL::PKey::RSA, nil] key material
        attr_reader :key

        def ensure_key!
          return if key.is_a? OpenSSL::PKey::RSA

          raise InvalidAlgorithm, 'signature algorithm and key does not match'
        end
      end
    end
  end
end
