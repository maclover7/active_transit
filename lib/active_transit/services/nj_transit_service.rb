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

    def destinations_for(train_id)
      page = fetch_train_data(train_id)
      page = Nokogiri::HTML(page)

      raw_destinations = page.css('td').select do |el|
        el.attr('style') ? el : next
      end

      serialized_destinations = []

      raw_destinations.each do |destination|
        text = destination.content.split('  ')
        station = text[0]

        if text[1] == 'DEPARTED'
          departed = true
          time = ''
        else
          departed = false
          time = text[1].split(' ')[1]
        end

        serialized_destinations << {
          name: station,
          time: time,
          departed: departed
        }
      end

      serialized_destinations
    end

    private

    def fetch_station_data(station)
      RestClient.get("http://dv.njtransit.com/mobile/tid-mobile.aspx?sid=#{station}").body
    end

    def fetch_train_data(train)
      RestClient.get("http://dv.njtransit.com/mobile/train_stops.aspx?train=#{train}").body
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
