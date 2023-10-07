# frozen_string_literal: true

require 'net/http'

require_relative 'message_signatures/version'

module Net
  class HTTP
    # A Ruby implementation of HTTP Message Signatures.
    #
    # @see {https://httpwg.org/http-extensions/draft-ietf-httpbis-message-signatures.html}
    module MessageSignatures
    end
  end
end
