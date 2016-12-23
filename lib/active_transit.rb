require 'active_support/core_ext/string/inflections'

module ActiveTransit
  def self.service(name)
    name = name.to_s.downcase
    require "active_transit/services/#{name}_service"
    ActiveTransit.const_get("#{name}_service".camelize)
  end
end
