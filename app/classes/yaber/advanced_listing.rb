class Yaber::AdvancedListing < Yaber
  attr_accessor :keywords, :results, :error

  def initialize(keywords, results, error)
    self.keywords = keywords
    self.results = results
    self.error = error
  end

  def self.advanced_finder_endpoint
    base_uri.concat("/search/FindingService/v1?")
  end

  def self.search(keywords, entries = nil, page = nil)
    keyword_string = keywords.tr(' ', '+')
    url = url_for_endpoint_and_operation(advanced_finder_endpoint, "findItemsAdvanced&keywords=#{ keyword_string }")
    url = url.concat("&outputSelector(1)=PictureURLLarge")
    url = url.concat("&outputSelector(2)=SellerInfo")
    url = url.concat("&paginationInput.pageNumber=#{page}") if page
    url = url.concat("&paginationInput.entriesPerPage=#{entries}") if entries
    response = get(url)

    results = []
    error = nil

    case response.code
    when 200
      listings = response.parsed_response["findItemsAdvancedResponse"]["searchResult"]
      items = Array.wrap(listings["item"])

      items.each do |f|
        details = f.select { |k,v| k=="itemId" || k=="title" || k=="galleryURL" || k=="viewItemURL" || k=="pictureURLLarge"}
        new_hash = {}
        new_hash["price"] = f["sellingStatus"]["currentPrice"]["__content__"]
        new_hash["endingAt"] = f["listingInfo"]["endTime"]
        new_hash["sellerName"] = f["sellerInfo"]["sellerUserName"]
        new_hash["sellerScore"] = f["sellerInfo"]["feedbackScore"]
        new_hash["sellerFeedbackPercent"] = f["sellerInfo"]["positiveFeedbackPercent"]
        details = details.merge(new_hash)
        results << details
      end

    when 404
      error = "nothing found"
    when 500..600
      error_code = "Errorrzzzz #{response.code}"
    end

    error = error ||= error_code

    self.new(keywords, results, error)
  end
end
