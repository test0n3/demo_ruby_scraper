require 'nokogiri'
require 'open-uri'

module Scraper
  def self.scrape_url url
    result = []
    return_text = -> (cell){ cell.nil? ? '' : cell.text.strip }

    doc = Nokogiri::HTML5(URI.open(url))

    if doc.errors.count > 0
      errors_messenger(doc)
      return
    end

    rows = doc.at('.wikitable').search('tbody').search('tr')
    t_head = rows.shift.search('th')

    rows.each do |row|
      cells = row.search('td')
      hash = {}
      t_head.each_with_index do |col, index|
        col_name = return_text.call(col)
        hash[col_name.to_sym] = return_text.call(cells[index])
      end
      result.push(hash)
    end
    result
  end

  private
  def self.errors_messenger(source)
    source.errors.each { |err| puts err }
  end
end

url = 'https://en.wikipedia.org/wiki/List_of_museums_in_Idaho'

puts Scraper.scrape_url(url)
