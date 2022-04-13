require 'nokogiri'
require 'open-uri'

class Scraper
  URL_TO_SCRAPE = 'https://en.wikipedia.org/wiki/List_of_museums_in_Idaho'
  def scrape_url
    result = []
    html = URI.open(URL_TO_SCRAPE)
    doc = Nokogiri::HTML5(html)

    if doc.errors.count > 0
      doc.errors.each do |err|
        puts err
      end
      return
    end
    rows = doc.at('.wikitable').search('tbody').search('tr')
    t_head = rows.shift.search('th')
    rows.first(5).each do |row|
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

  def return_text(cell)
    cell.nil? ? '' : cell.text.strip
  end
end

# scrape = Scraper.new

# puts (scrape.scrape_url)
