fx_version "cerulean"
game "gta5"
lua54 "yes"

name "Fivem_Bridge"

author "ShitDevScripts"
description "Fivem_Bridge is a framework agnostic resource that provides a simple way to create bridges between your resources and other resources."
version "0.0.6"

dependencies {
    "ox_lib",
}

shared_scripts {
    "@ox_lib/init.lua",
    "config/bridge_resources.lua",
    "config/auto_detect.lua",
    "utility/shared/shims.lua",
    "import.lua",
    "utility/shared/locale.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
}

files {
    "import.lua",
    "modules/**/client.lua",
    "modules/**/server.lua",
    "modules/**/shared.lua",
    "modules/framework/*.lua",
    "locales/*.json",
    "utility/shared/*.lua",
}

exports {
    "BridgeEnvironment",
    "Framework",
    "Inventory",
    "Banking",
    "Locale",
    "Locales",
    "Notify",
}
