class YaberProduct < Yaber
  attr_accessor :epid, :fitments, :notes

  def initialize(epid, fitments, notes)
    self.epid = epid
    self.fitments = fitments
    self.notes = notes
  end

  def self.product_endpoint
    base_uri.concat("/marketplacecatalog/ProductService/v1?")
  end

  def self.part_compatibilities_for(epid, page = nil)
    url = url_for_endpoint_and_operation(product_endpoint, "getProductCompatibilities&productIdentifier.ePID=#{epid}")
    url = url.concat("&paginationInput.pageNumber=#{page}") if page
    response = get(url).parsed_response
  end

  def self.fitments_for(epid)
    notes = []
    fitments = []
    current_page = 0
    total_pages = 1 # Hack. Set this to begin with 1 since there will always be at least one page

    until current_page == total_pages
      response = part_compatibilities_for(epid, current_page + 1)["getProductCompatibilitiesResponse"]
      break unless response["compatibilityDetails"]
      total_pages = response["paginationOutput"]["totalPages"].to_i
      current_page = response["paginationOutput"]["pageNumber"].to_i
      compatibilities = Array.wrap(response["compatibilityDetails"])

      compatibilities.each do |c|
        fitments << property_details_to_hash(c["productDetails"])
        notes << property_detail_to_hash(c["notes"]["noteDetails"]) if c["notes"]
      end
    end

    YaberProduct.new(epid, fitments, notes)
  end
end
