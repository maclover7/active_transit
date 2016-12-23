require 'active_transit/service'

module ActiveTransit
  class WmataService < Service
    def initialize(api_key)
      @api_key = api_key
    end
  end
end
