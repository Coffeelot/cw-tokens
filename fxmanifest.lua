fx_version 'cerulean'

game 'gta5'

ui_page 'html/index.html'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua',
}

client_scripts{
    'client/*.lua',
}

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

files {
    'html/index.html',
    'html/index.js'
}

dependency{
    'oxmysql',
}

exports {
    'getAllTokens',
    'getToken',
    'hasToken'
}