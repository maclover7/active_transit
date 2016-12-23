require 'active_transit/service'

require 'rest-client'
require 'json'
require 'nokogiri'
require 'active_support/core_ext/string/inflections'

module ActiveTransit
  def self.service(name, *args)
    name = name.to_s.downcase
    require "active_transit/services/#{name}_service"
    ActiveTransit.const_get("#{name}_service".camelize).new(*args)
  end
end
