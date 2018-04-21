require 'rubygems'
require 'nokogiri'  # Gem Nokogiri pour ouvrir les pages HTML
require 'open-uri'  # Fonctionnalité Ruby, à ne pas mettre dans le Gemfile

  # Website choisi pour l'exercice : www.alloweb.org/annuaire-startups/annuaire-incubateurs-startups/
  # Y'a pas les Code Postaux par contre

def get_incubator_link(url)  # Cette méthode servira à récupérer le lien vers le site de chaque incubateur
  page = Nokogiri::HTML(open("#{url}"))  # On ouvre la page d'infos de l'incubateur depuis notre liste d'URLs
  link = page.css("div.wpb_wrapper p a")  # On sélectionne les objets "liens" dans les paragraphes u div.wpb_wrapper
  links = []  # On crée un tableau vide
    link.each do |link|  # Pour chaque objet lien trouvé sur la page
    links << link["href"]  # On rentre la valeur de l'attribur "href" (donc l'url)
    end
  return links[6]  # On récupère la 7è valeur de notre tableau, qui correspondra toujours au lien de "site Internet"
end

def get_incubator_name(url)  # Cette méthode servira à récupérer le nom de chaque incubateur
  app_page = Nokogiri::HTML(open("#{url}"))  # On ouvre la page d'infos de l'incubateur depuis notre liste d'URLs
  name = app_page.css("div.detail-banner-wrapper h1").text.slice!(1..-1).gsub!("  Revendication ","")
  return name  # On a choisi de récupérer le nom dans le titre h1 de la page, on supprime l'espace devant le texte avec slice!
end            # Puis on remplace par un vide ("") le texte parasite qu'on retrouve à chaque occurence grâce à gsub!

def get_incubators_list()  # Cette méthode comptera le nombre de pages sur le menu principal et y accèdera
  main_page = Nokogiri::HTML(open("http://www.alloweb.org/annuaire-startups/annuaire-incubateurs-startups/"))  # Ouvre l'accueil
  last = main_page.css("/html/body/div[1]/div/div/div/div[2]/div[1]/div/nav/div/a[5]").text.to_i  # Cherche le numéro de la dernière page grâce au bouton de navigation
  lists = []
  0.upto(last) do |i|  # On boucle depuis 0 (la page en cours) jusqu'à l'index de la dernière page
    main_page = Nokogiri::HTML(open("http://www.alloweb.org/annuaire-startups/annuaire-incubateurs-startups/page/#{i}"))  # On ouvre chaque page du menu en remplaçant le numéro de l'URL par chaque itération de boucle
    list = main_page.css("a.listing-row-image-link")  # On prend le lien vers la page d'infos de l'incubateur depuis l'image
    list.each do |list|  # Pour chaque image récupérée
      lists << list["href"]  # On stocke la valeur "href", donc l'URL vers la page d'infos dans un tableau
    end
    i += 1  # On incrémente notre compteur en fin de boucle pour passer à la page suivante
  end
    return lists  # On retourne notre tableau complet, avec toutes les URLs de toutes les pages du menu
end

def perform
  data_base = {}  # On crée notre Hash final
  urls = get_incubators_list  # On appelle notre méthode pour récupérer la liste des URLs vers les pages d'infos des incubateurs
    urls.each do |url|  # Pour chaque URL du tableau
      name = get_incubator_name(url)  # Enregistre le nom
      link = get_incubator_link(url)  # Enregistre le lien vers le site
      data_base[name] = link  # On écrit dans le Hash final nom en clé et lien en valeur
    end
  return data_base
end
print perform  # On peut voir notre magnifique Hash qui contient les 366 boîtes rencensées sur l'annuaire !
