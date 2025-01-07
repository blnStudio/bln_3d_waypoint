fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'BLN Studio <bln.tebex.io>'
description 'A sleek and performant waypoint indicator system that shows a dynamic 3D marker pointing to your destination.'
version '2.0.1'

client_scripts {
    'c/*.lua'
}

server_scripts {
    'vcheck.lua'
}

shared_script 'config.lua'
