# frozen_string_literal: true

require 'net/http'

require 'net/http/message_signatures/rsa_pss_sha512'
require 'net/http/message_signatures/signature'
require 'net/http/message_signatures/signature_algorithm'
require 'net/http/message_signatures/version'

module Net
  class HTTP
    # A Ruby implementation of HTTP Message Signatures.
    #
    # @see {https://httpwg.org/http-extensions/draft-ietf-httpbis-message-signatures.html}
    module MessageSignatures
    end
  end
end
