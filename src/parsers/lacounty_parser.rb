require 'open-uri'
require 'json'

class LacountyParser
  attr :id


  def initialize(id)
    @id = id
  end

  def fetch()
    details = fetch_details()

    details['events'] = fetch_events()

    details
  end

  def fetch_details()
    source = open('https://portal.assessor.lacounty.gov/api/parceldetail?ain=' + @id.to_s)
    data = JSON.load(source)

    {
        address: data['Parcel']['SitusStreet'] + data['Parcel']['SitusCity'] + data['Parcel']['SitusZipCode'],
        use_type: data['Parcel']['UseType'],
        status: data['Parcel']['TaxStatus'],
        year_defaulted: data['Parcel']['TaxDefaultedYear'],
        year_built: data['Parcel']['YearBuilt'],
    }
  end

  def fetch_events()
    source = open('https://portal.assessor.lacounty.gov/api/parcel_ownershiphistory?ain=' + @id.to_s)
    data = JSON.load(source)

    result = []
    data['Parcel_OwnershipHistory'].each do |key, value|
      event = {
          date: key['RecordingDate'],
          reassessed: key['IsReassessed'],
          value: key['AssessedValue'].to_i || 0,
      }
      result.push(event)
    end

    result
  end
end