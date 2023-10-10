# frozen_string_literal: true

require 'net/http'

require 'net/http/structured_field_values'

module Net
  class HTTP
    module MessageSignatures
      # An HTTP Message Signature with its covered components and parameters.
      #
      # @see {https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-message-signatures-19#section-3}
      class Signature
        include StructuredFieldValues

        # @return [String, nil] signature value in binary
        attr_accessor :signature
        # @return [Hash{String, ParameterizedValue => String}] map of covered components' name (and optional params) and
        #                                                      value
        attr_reader :covered_components
        # @return [Hash{String => Object}] map of signature parameters' name and value
        attr_reader :params
        # @return [SignatureAlgorithm] signature algorithm which can be used without key material
        attr_writer :algorithm

        # @param [String] signature signature value in binary
        # @param [Hash{String, ParameterizedValue => String}] covered_components map of covered components' name (and
        #                                                                        optional params) and value
        # @param [Hash{String => Object}] params map of signature parameters' name and value
        # @param [SignatureAlgorithm] algorithm signature algorithm which can be used without key material
        def initialize(signature: nil, covered_components: {}, params: {}, algorithm: nil)
          @signature = signature
          @covered_components = covered_components
          @params = params
          @algorithm = algorithm
        end

        # Verifies the signature.
        # Will raise error if it is invalid.
        #
        # @see {https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-message-signatures-19#section-3.2}
        def verify!
          return if algorithm.verify(signature_base, signature)

          raise VerificationError, 'signature verification failed'
        end

        private

        # @return [SignatureAlgorithm, nil] signature algorithm which can be used without key material
        attr_reader :algorithm

        # Creates the signature parameters component value.
        #
        # @see {https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-message-signatures-19#section-2.3}
        #
        # @return [ParameterizedValue] the signature parameters component value
        def signature_params
          ParameterizedValue.new(covered_components.keys, params)
        end

        # Creates the signature base from HTTP message components covered by the signature.
        #
        # @see {https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-message-signatures-19#section-2.5}
        #
        # @return [String] the signature base
        def signature_base
          components = covered_components
                       .merge({ '@signature-params' => Serializer.serialize_as_inner_list(signature_params) })
          components.map do |name, value|
            serialized_name = Serializer.serialize(name)
            "#{serialized_name}: #{value}"
          end.join("\n").encode(Encoding::ASCII)
        end

        class VerificationError < StandardError; end
      end
    end
  end
end
