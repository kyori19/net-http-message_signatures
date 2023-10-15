# frozen_string_literal: true

require 'net/http'

module Net
  class HTTP
    module MessageSignatures
      # Abstract representation of HTTP Signature Algorithms.
      #
      # To instantiate this class, you must pass the key material.
      # With that instance, HTTP_VERIFY method can be used without passing key material.
      #
      # @see {https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-message-signatures-19#section-3.3}
      class SignatureAlgorithm
        # HTTP_VERIFY method which can be used without verification key material
        #
        # @param [String] message the signature base in binary
        # @param [String] signature the signature in binary
        # @return [Boolean] whether signature is valid or not
        def verify(message, signature)
          # :nocov:
          raise NotImplementedError, 'signature algorithm must implement #verify'
          # :nocov:
        end

        class InvalidAlgorithm < StandardError; end
      end
    end
  end
end
