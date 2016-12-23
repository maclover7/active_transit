module ActiveTransit
  class MetroNorthService < Service
    STATION_ENDPOINT = 'http://as0.mta.info/mnr/mstations/station_status_display.cfm'
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

    private

    def fetch_station_data(station_id)
      RestClient.post(STATION_ENDPOINT, { 'P_AVIS_ID': station_id, 'Get Train Status': 'Get Train Status' }).body
    end
  end
end
