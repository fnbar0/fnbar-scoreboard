fx_version "cerulean"
lua54 "yes"

author 'fnbar'
description "cool scoreboard"
game "gta5"
version '1.0.0'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
	'nui/script.js',
	'nui/style.css',
}
