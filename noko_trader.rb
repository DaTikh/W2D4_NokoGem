require 'rubygems'
require 'nokogiri'  # Gem Nokogiri pour ouvrir les pages HTML
require 'open-uri'  # Fonctionnalité Ruby, à ne pas mettre dans le Gemfile

def get_data
  page = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))  # On ouvre la page qui liste toutes les cryptos
  currency = page.css("td.currency-name")  # On sélectionne le marqueur CSS correspondant à la classe unique "currency-name" du td
  values = page.css("a.price")  # On fait la même chose pour la classe "price" des liens a
  currencies = []  # On crée deux tableaux vides pour stocker les données
  prices = []

  currency.each do |curr|  # On boucle sur chaque occurence de la classe "currency-name"
    currencies << curr['data-sort']  # Pour chaque on stocke dans notre tableau vide la valeur en cours avec l'attribut "data-sort"
  end                                # car c'est ici qu'est inscrit le nom COMPLET de chaque crypto

  values.each do |val|  # On fait la même chose pour la classe "price" 
    prices << val['data-usd']  # Cette fois-ci l'attribut est "data-usd"
  end

  # On a donc désormais deux tableaux, un pour les noms de cryptos et l'autre avec les prix.
  # Il faut maintenant les réunir dans un Hash qui prendra le nom en clé et le prix en valeur.
  # Pour ça on utilise la méthode .zip, qui permet d'utiliser chacun des noms pour l'associer aux clés du Hash
  # Puis en valeur du Hash on utilise la méthode .map pour itérer sur chaque instance du tableau prix
  data = Hash[currencies.zip(prices.map {|i| i.include?(',') ? (i.split /, /) : i})] 
end

def perform
  loop do
    p get_data  # On peut contempler notre hash de 1500+ données Crypto => Prix !
    sleep 3600  # Relance le prog toutes les heures. Normalement faudrait enlever le nombre de secondes que prend le prog à tourner.
  end
end

perform
