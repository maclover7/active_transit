require 'active_transit/service'

require 'nokogiri'
require 'rest-client'

module ActiveTransit
  class NjTransitService < Service
    def departures_for_station_id(station_id)
      page = fetch_station_data(station_id)
      page = Nokogiri::HTML(page)
      raw_trains = page.css('tr').select do |el|
        next unless el.attr('style')
        el.children.select { |el2| el2.name == 'td' }.length == 6
      end

      serialized_trains = []

      raw_trains.each do |train|
        serialized_trains << {
          time: train.children[1].children[0].children[0].text.strip,
          destination: train_destination(train),
          track: train_track(train),
          line: train.children[7].children[0].children[0].text,
          number: train.children[9].children[0].children[0].text,
          status: train.children[11].children[0].children[0].text.strip
        }
      end

      serialized_trains
    end

    def departures_for_station_name(station_name)
      departures_for_station_id(station_name)
    end

    private

    def fetch_station_data(station)
      RestClient.get("http://dv.njtransit.com/mobile/tid-mobile.aspx?sid=#{station}").body
    end

    def train_destination(train)
      str = ""

      train.children[3].children[0].children.each do |c|
        str << c.text
      end

      str
    end

    def train_track(train)
      children = train.children[5].children[0].children

      if children.any?
        children[0].text
      else
        ""
      end
    end
  end
end
