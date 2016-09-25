require 'httparty'

class Yaber
  include HTTParty
  # For some reason this isn't working. For the time being we have to
  # specifically set the base_uri
  # base_uri 'http://svcs.ebay.com/services/'

  def self.base_uri
    "http://svcs.ebay.com/services"
  end

  def self.url_for_endpoint_and_operation(endpoint, operation)
    url = endpoint
    url.concat("SERVICE-VERSION=#{version}")
    url.concat("&SECURITY-APPNAME=#{api_key}")
    url.concat("&GLOBAL-ID=#{global_id}")
    url.concat("&OPERATION-NAME=#{operation}")
  end

  def self.property_details_to_hash(property_details)
    hash = {}
    property_details.each do |f|
      if f["value"].class == Hash
        if f["value"].keys[0] == "text"
          hash[f["propertyName"].downcase.tr(' ', '_').to_sym] = f["value"]["text"]["value"]
        elsif f["value"].keys[0] == "number"
          hash[f["propertyName"].downcase.tr(' ', '_').to_sym] = f["value"]["number"]["value"]
        end
      end
    end
    hash
  end

  def self.property_detail_to_hash(detail)
    hash = {}
    hash[detail["propertyName"].downcase.tr(' ', '_').to_sym] = detail["value"]["text"]["value"]
  end

  private

    def self.version
      "1.3.0"
    end

    def self.api_key
      ENV['EBAY_API_KEY']
    end

    def self.global_id
      "EBAY-US"
    end
end



  # // API request variables
  # $endpoint = 'http://svcs.ebay.com/services/search/FindingService/v1';  // URL to call
  # $version = '1.0.0';  // API version supported by your application
  # $appid = 'MyAppID';  // Replace with your own AppID
  # $globalid = 'EBAY-US';  // Global ID of the eBay site you want to search (e.g., EBAY-DE)
  # $query = 'harry potter';  // You may want to supply your own query
  # $safequery = urlencode($query);  // Make the query URL-friendly
  #
  # // Construct the findItemsByKeywords HTTP GET call
  # $apicall = "$endpoint?";
  # $apicall .= "OPERATION-NAME=findItemsByKeywords";
  # $apicall .= "&SERVICE-VERSION=$version";
  # $apicall .= "&SECURITY-APPNAME=$appid";
  # $apicall .= "&GLOBAL-ID=$globalid";
  # $apicall .= "&keywords=$safequery";
  # $apicall .= "&paginationInput.entriesPerPage=3";
