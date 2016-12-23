module ActiveTransit
  class Service
    def departures_for_station_id(station_id)
      raise NotImplementedError
    end

    def departures_for_station_name(station_name)
      raise NotImplementedError
    end

    def destinations_for(train_id)
      raise NotImplementedError
    end
  end
end
