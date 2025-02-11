Config = {}

Config.GroupSettings = {
    ['best'] = { -- group name
        title = 'Owner', -- if not specified, it will use group name
        color = {r = 11, g = 112, b = 242, a = 255}
    },
    ['admin'] = {
        title = 'Admin',
        color = {r = 255, g = 0, b = 0, a = 255}
    },
    ['mod'] = {
        title = 'Moderator',
        color = {r = 0, g = 255, b = 0, a = 255}
    },
    ['user'] = {
        title = 'Player',
        color = {r = 255, g = 255, b = 255, a = 255}
    }
}

Config.CustomTags = { -- require changing ESX core es_extended/server/classes/player.lua  - stateBag:set("license", self.license, false) and setting this from false to true :/
    ['license:da8fd89ffa9dd4b082e6dc1f34f8ff653c33a9a6'] = {
        title = 'Sigma 🗿',
        color = {r = 220, g = 20, b = 60, a = 255}
    }
}

Config.Slowmotion = false -- whether to decrease player speed when using scoreboard

Config.UsingText = '💀' -- text appearing on players that use scoreboard

Config.DrawDistance = 40 -- max distance for drawing player info