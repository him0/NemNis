require 'net/http'
require 'uri'
require 'json'

module NemNis
  module RestUtils
  module_function

    def get(url)
      url = URI.parse(url) if url.class == String
      
      begin
        request = Net::HTTP::Get.new(url.path)
        response = Net::HTTP.start(url.host, url.port) {|http|
          http.request(request)
        }
        json = JSON.parse(response.body)
      rescue
        raise
      end

      return json
    end

  end
end
