require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students=doc.css('div.student-card').map do |card|
       {:name => card.css('h4.student-name').text,
       :location => card.css('p.student-location').text,
       :profile_url => card.css('a').attribute('href').value}
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    # binding.pry
    student={
      profile_quote: doc.css(".profile-quote").text,
      bio: doc.css("div.bio-content.content-holder div.description-holder p").text
    }
    
    links = doc.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end
    
    
    student
  end

end

