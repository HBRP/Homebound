fx_version "adamant"
game "gta5"

author "Trsak"

description "ESX Inventory HUD"

version "2.4.0"

ui_page "html/ui.html"

client_scripts {
  "client/main.lua",
  "client/trunk.lua",
  "client/property.lua",
  "client/player.lua",
  "client/shops.lua",
  "client/storage.lua",
  "locales/*.lua",
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

  "em_fw",
  "em_items",
  't-notify'

}