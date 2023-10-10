# frozen_string_literal: true

require 'net/http'

module Net
  class HTTP
    module MessageSignatures
      # Abstract representation of HTTP Signature Algorithms.
      #
      # To instantiate this class, you must pass the key material.
      # With that instance, both of HTTP_SIGN and HTTP_VERIFY method can be used without passing key material.
      #
      # @see {https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-message-signatures-19#section-3.3}
      class SignatureAlgorithm
        # HTTP_SIGN method which can be used without signing key material
        #
        # @param [String] message the signature base in binary
        # @return [String] the signature in binary
        def sign(message)
          raise NotImplementedError, 'signature algorithm must implement #sign'
        end

        # HTTP_VERIFY method which can be used without verification key material
        #
        # @param [String] message the signature base in binary
        # @param [String] signature the signature in binary
        # @return [Boolean] whether signature is valid or not
        def verify(message, signature)
          raise NotImplementedError, 'signature algorithm must implement #verify'
        end

        class InvalidAlgorithm < StandardError; end
      end
    end
  end
end
