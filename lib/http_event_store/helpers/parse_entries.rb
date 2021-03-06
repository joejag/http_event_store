require 'time'

module HttpEventStore
  module Helpers
    class ParseEntries

      def call(entries)
        entries.collect do |entry|
          create_event(entry)
        end.compact
      end

      private

      def create_event(entry)
        id = entry['eventNumber']
        event_id = entry['eventId']
        type = entry['eventType']
        source_event_uri = entry['id']
        return nil unless entry['data']
       
        begin
          data = JSON.parse(entry['data'])
        rescue JSON::ParserError
          return nil
        end

        stream_name = entry['streamId']
        position = entry['positionEventNumber']
        created_time = entry['updated'] ? Time.parse(entry['updated']) : nil
        Event.new(type, data, source_event_uri, event_id, id, position, stream_name, created_time)
      end
    end
  end
end
