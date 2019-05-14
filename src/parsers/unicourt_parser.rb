require 'open-uri'
require 'nokogiri'
require 'json'

class UnicourtParser
  attr :link
  attr :items
  attr :depth


  def initialize(link, depth = 3)
    @link = link
    @depth = depth
    @items = []

  end

  def fetch()
    collect_items()

    fetch_details()
  end

  def fetch_details()
    result = []
    @items.each do |link|
      source = open(link)
      doc = Nokogiri::HTML(source)

      spans = doc.css('span._p')

      item = {
          link: link,
          filling_date: spans[1].text,
          decedent: spans[9].text

      }
      result.push(item)
    end

    result
  end

  def collect_items(page = 1)
    source = open(@link)
    doc = Nokogiri::HTML(source)

    doc.css('div.case a').each do |el|
      @items.push(el['href'])
    end

    next_button = doc.css('a.pagination-next')

    unless next_button.nil?
      if @depth >= page
        @link = next_button.first['href']
        page += 1
        collect_items(page)
      end
    end
  end
end