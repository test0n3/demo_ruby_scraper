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

    rows = doc.at('.wikitable').at('tbody').search('tr')
    rows.each do |row|
      cells = row.search('td')

      result.push({ title: return_text(cells[0]),
                    town: return_text(cells[1]),
                    county: return_text(cells[2]),
                    region: return_text(cells[3]),
                    type: return_text(cells[4]),
                    summary: return_text(cells[5]) })
    end
    result
  end

  def return_text(cell)
    cell.nil? ? '' : cell.text.strip
  end
end

# scrape = Scraper.new

# puts (scrape.scrape_url)
