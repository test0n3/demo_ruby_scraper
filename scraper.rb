require 'nokogiri'
require 'open-uri'

class Scraper
  attr_reader :url_to_scrape

  def initialize(url_to_scrape = nil)
    @url_to_scrape = url_to_scrape
  end

  def scrape_url
    result = []
    doc = Nokogiri::HTML5(URI.open(@url_to_scrape))

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
        col_name = return_text(col)
        hash[col_name.to_sym] = return_text(cells[index])
      end
      result.push(hash)
    end
    result
  end

  private
  def return_text(cell)
    cell.nil? ? '' : cell.text.strip
  end
  
  def errors_messenger(source)
    source.errors.each do |err|
      puts err
    end
  end
end

# scrape = Scraper.new('https://en.wikipedia.org/wiki/List_of_museums_in_Idaho')
scrape = Scraper.new('https://en.wikipedia.org/wiki/List_of_museums_in_Illinois')
# scrape = Scraper.new('https://www.google.com/')

puts (scrape.scrape_url)
