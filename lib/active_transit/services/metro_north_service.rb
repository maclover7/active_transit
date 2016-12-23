module ActiveTransit
  class MetroNorthService < Service
    STATION_ENDPOINT = 'http://as0.mta.info/mnr/mstations/station_status_display.cfm'
    STATIONS_ENDPOINT = 'http://as0.mta.info/mnr/mstations/default.cfm'
    TRAIN_COLORS = {
      "#EE0034" => "New Haven", "#0039A6" => "Harlem", "#009B3A" => "Hudson"
    }

    def departures_for_station_id(station_id)
      page = fetch_station_data(station_id)
      page = Nokogiri::HTML(page)

      raw_trains = page.css('tr').select do |el|
        el.attr('bgcolor') &&
          el.children.select { |el2| el2.name == 'form' }.length == 1
      end

      serialized_trains = []

      raw_trains.each do |train|
        serialized_trains << {
          time: train.children[1].content.strip,
          destination: train.children[3].content,
          track: train.children[5].content,
          line: TRAIN_COLORS[train.attr('bgcolor')],
          status: train.children[7].content
        }
      end

      serialized_trains
    end

    def departures_for_station_name(station_name)
      station = fetch_stations.select { |name, _id| name == station_name }
      departures_for_station_id(station[station_name])
    end

    private

    def fetch_station_data(station_id)
      RestClient.post(STATION_ENDPOINT, { 'P_AVIS_ID': station_id, 'Get Train Status': 'Get Train Status' }).body
    end

    def fetch_stations
      @stations ||= begin
        page = RestClient.get(STATIONS_ENDPOINT)
        page = Nokogiri::HTML(page)

        raw_stations = page.css('option').select do |el|
          !el.attr('value').nil?
        end

        serialized_stations = {}

        raw_stations.each do |station|
          id, name = station.attr('value').split(',')
          serialized_stations[name] = id
        end

        serialized_stations
      end
    end
  end
end
