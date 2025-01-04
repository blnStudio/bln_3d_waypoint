Config = {
    defaultBlip = {
        sprite = "blip_deadeye_cross",
        color = {232, 16, 5}                -- R,G,B color, Default red 
    },
    
    display = {
        spriteSize = {0.02, 0.035},         -- width, height
        textScale = 0.25,
        textColor = {255, 255, 255, 255},   -- White text
        textFont = 4,
        textOffset = 0.025,
        minDistance = 2.0,                  -- Minimum distance to hide waypoint
        heightOffset = 0.0                  -- Offset from ground
    },
    
    commands = {
        toggle = "togglewaypoint"           -- Command to toggle waypoint visibility
    }
}


-- Blip sprite names: https://github.com/femga/rdr3_discoveries/blob/master/useful_info_from_rpfs/textures/blips/README.md