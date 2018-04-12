require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'yaml'

def get_incubator_link(url)
  page = Nokogiri::HTML(open("#{url}"))
  link = page.css("div.wpb_wrapper p a")
  links = []
    link.each do |link|
    links << link["href"]
    end
  return links[6]
end

def get_incubator_name(url)
  app_page = Nokogiri::HTML(open("#{url}"))
  name = app_page.css("div.detail-banner-wrapper h1").text.slice!(1..-1).gsub!("  Revendication ","")
  return name
end

def get_incubators_list()
  main_page = Nokogiri::HTML(open("http://www.alloweb.org/annuaire-startups/annuaire-incubateurs-startups/"))
  last = main_page.css("/html/body/div[1]/div/div/div/div[2]/div[1]/div/nav/div/a[5]").text.to_i
  lists = []
  0.upto(last) do |i|
    main_page = Nokogiri::HTML(open("http://www.alloweb.org/annuaire-startups/annuaire-incubateurs-startups/page/#{i}"))
    list = main_page.css("a.listing-row-image-link")
    list.each do |list|
      lists << list["href"]
    end
    i += 1
  end
    return lists
end

def perform
  urls = []
  data_base = {}
  zlist = get_incubators_list
    zlist.map do |i|
      urls << i
    end
    urls.each do |url|
      name = get_incubator_name(url)
      link = get_incubator_link(url)
      data_base[name] = link
    end
  return data_base
end
print perform
