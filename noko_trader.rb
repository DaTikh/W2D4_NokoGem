require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'yaml'

def get_data
  page = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
  currency = page.css("td.currency-name")
  values = page.css("a.price")
  currencies = []
  prices = []

  currency.each do |curr|
    currencies << curr['data-sort']
  end

  values.each do |val|
    prices << val['data-usd']
  end

  data = Hash[currencies.zip(prices.map {|i| i.include?(',') ? (i.split /, /) : i})]
end

print get_data
