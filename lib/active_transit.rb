require 'active_support/core_ext/string/inflections'

module ActiveTransit
  def self.service(name)
    ActiveTransit.const_get("#{name.to_s.downcase}_service".camelize)
  end
end
