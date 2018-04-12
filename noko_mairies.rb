require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'yaml'

def get_all_the_urls_of_val_doise_townhalls()
  page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
  links_list = []
  table_links = page.css("a.lientxt")
  table_links.each do |link|
    links_list << "#{link['href'].sub(/./, "http://annuaire-des-mairies.com")}"
  end
  return links_list
end

def get_the_email_of_a_townhal_from_its_webpage(url)
  mairie_info = {}
  url.each do |url|
    page = Nokogiri::HTML(open(url))
    mairie = page.css("/html/body/div/main/section[1]/div/div/div/h1").text.gsub(" - ","").gsub!(/[0-9]/, "")
    mairie = camel_name(mairie)
    mairie_mail = page.css("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
    mairie_info[mairie] = mairie_mail
  end
   return mairie_info
end

def camel_name(a)
  if a.include?("-")
    b = a.downcase!.split("-")
    b[1..-1].each do |b|
    b = b.capitalize!
    end
  return b.join("")
  else
  return a.downcase!
  end
end

def perform()
  urls = get_all_the_urls_of_val_doise_townhalls()
  get_the_email_of_a_townhal_from_its_webpage(urls)
end

puts perform
