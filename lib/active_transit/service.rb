module ActiveTransit
  class Service
    def self.departures_for_station_id(station_id)
      raise NotImplementedError
    end

    def self.departures_for_station_name(station_name)
      raise NotImplementedError
    end

    def self.destinations_for(train_id)
      raise NotImplementedError
    end
  end
end
