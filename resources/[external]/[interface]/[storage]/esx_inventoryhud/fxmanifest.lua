fx_version 'bodacious'
game "gta5"

ui_page "html/ui.html"

client_scripts {
  "client/main.lua",
  "client/shops.lua",
  "config.lua"
}


files {
  "html/ui.html",
  "html/css/ui.css",
  "html/css/jquery-ui.css",
  "html/js/inventory.js",
  "html/js/config.js",
  -- JS LOCALES
  "html/locales/*.js",
  -- IMAGES
  "html/img/bullet.png",
  -- ICONS
  "html/img/items/*.png"
}

dependencies {

  "em_dal",
  "em_items",
  "em_storage",
  "em_transactions",
  "t-notify"

}