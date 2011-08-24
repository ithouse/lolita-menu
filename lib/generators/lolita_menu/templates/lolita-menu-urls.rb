Lolita::Menu::Urls.create do 
 # add url and/or label to autocomplete list
 # add "/contacts", "Contacts"
 # add "/pages/my-contact-page"
 # add root_path
 # # You can collect data from you models
 # Pages.where("created_at > ?", 30.days.ago).each do |page|
 #   add page_path(page), page.title
 # end
end