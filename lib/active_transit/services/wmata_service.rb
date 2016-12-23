module ActiveTransit
  class WmataService < Service
    STATION_ENDPOINT = 'https://api.wmata.com/StationPrediction.svc/json/GetPrediction/'
    STATIONS_ENDPOINT = 'https://api.wmata.com/Rail.svc/json/jStations'

    def initialize(api_key)
      @api_key = api_key
    end

    def departures_for_station_id(station_id)
      fetch_station_data(station_id)
    end

    def departures_for_station_name(station_name)
      stations = fetch_stations.select { |s| s['Name'] == station_name }
      trains = []

      stations.each do |station|
        trains << departures_for_station_id(station['Code'])
      end

      trains
    end

    def destinations_for(train_line)
      fetch_stations({ 'LineCode': train_line})
    end

    private

    def fetch_station_data(station_id)
      url = STATION_ENDPOINT + station_id
      trains = RestClient.get(url, params: { 'api_key': @api_key }).body
      trains = JSON.parse(trains)['Trains']
      trains
    end

    def fetch_stations(params = {})
      @stations ||= begin
        params.merge!({ 'api_key': @api_key })
        stations = RestClient.get(STATIONS_ENDPOINT, params: params).body
        stations = JSON.parse(stations)['Stations']
        stations
      end
    end
  end
end
