local waypoint = nil
local lastWaypointStatus = false
local isEnabled = true
local customDestination = nil
local GetWaypointCoords = GetWaypointCoords
local IsWaypointActive = IsWaypointActive
local GetEntityCoords = GetEntityCoords
local PlayerPedId = PlayerPedId
local GetScreenCoordFromWorldCoord = GetScreenCoordFromWorldCoord
local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord
local floor = math.floor
local vector3 = vector3
local DrawSprite = DrawSprite
local SetTextScale = SetTextScale
local SetTextFontForCurrentCommand = SetTextFontForCurrentCommand
local SetTextColor = SetTextColor
local SetTextCentre = SetTextCentre
local SetTextDropshadow = SetTextDropshadow
local DisplayText = DisplayText
local CreateVarString = CreateVarString

local cachedGroundZ = {}
local function GetCachedGroundZ(x, y)
    local key = string.format("%.1f%.1f", x, y)
    if not cachedGroundZ[key] then
        local ground, z = GetGroundZFor_3dCoord(x, y, 1000.0, true)
        if ground then
            cachedGroundZ[key] = z + Config.display.heightOffset
        else
            cachedGroundZ[key] = 0.0
        end
    end
    return cachedGroundZ[key]
end

local function DrawWaypointIndicator(x, y, distance, blipName, blipColor)
    local r, g, b = table.unpack(blipColor or Config.defaultBlip.color)
    DrawSprite("generic_textures", "default_pedshot", x, y, 0.02, 0.035, 0.0, 255, 255, 255, 200, 0)
    local w, h = table.unpack(Config.display.spriteSize)
    DrawSprite(
        "BLIPS", 
        blipName or Config.defaultBlip.sprite, 
        x, y, 
        w,h,
        0.0, r, g, b, 200, 0
    )
    
    local text = tostring(floor(distance)) .. "m"
    SetTextScale(Config.display.textScale, Config.display.textScale)
    SetTextFontForCurrentCommand(Config.display.textFont)
    SetTextColor(table.unpack(Config.display.textColor))
    SetTextCentre(true)
    SetTextDropshadow(1, 0, 0, 0, 255)
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y + Config.display.textOffset)
end

function SetCustomDestination(coords, blipName, blipColor)
    if not coords then return end
    customDestination = {
        coords = vector3(coords.x, coords.y, coords.z or GetCachedGroundZ(coords.x, coords.y)),
        blip = blipName,
        color = blipColor
    }
    return true
end

function RemoveCustomDestination()
    customDestination = nil
    return true
end

RegisterCommand(Config.commands.toggle, function()
    isEnabled = not isEnabled
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 255},
        args = {'System', isEnabled and 'Waypoint indicator enabled' or 'Waypoint indicator disabled'}
    })
end, false)

Citizen.CreateThread(function()
    while true do
        local isWaypointActive = IsWaypointActive()
        
        if not customDestination and isWaypointActive ~= lastWaypointStatus then
            if isWaypointActive then
                local waypointCoords = GetWaypointCoords()
                waypoint = vector3(waypointCoords.x, waypointCoords.y, GetCachedGroundZ(waypointCoords.x, waypointCoords.y))
            else
                waypoint = nil
                cachedGroundZ = {}
            end
            lastWaypointStatus = isWaypointActive
        end
        
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        local destination = customDestination and customDestination.coords or waypoint
        
        if isEnabled and destination then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - destination)

            local uiapp = GetUiappCurrentActivityByHash(`Map`)
            
            if distance > Config.display.minDistance  and uiapp == GetHashKey("Map") then
                local isVisible, screenX, screenY = GetScreenCoordFromWorldCoord(
                    destination.x, 
                    destination.y, 
                    destination.z
                )
                
                if isVisible then
                    if customDestination then
                        DrawWaypointIndicator(
                            screenX, screenY, distance, 
                            customDestination.blip, 
                            customDestination.color
                        )
                    else
                        DrawWaypointIndicator(screenX, screenY, distance)
                    end
                end
                Citizen.Wait(0)
            else
                Citizen.Wait(100)
            end
        else
            Citizen.Wait(250)
        end
    end
end)



exports('SetCustomDestination', SetCustomDestination)
exports('RemoveCustomDestination', RemoveCustomDestination)

RegisterNetEvent('waypointIndicator:setDestination')
AddEventHandler('waypointIndicator:setDestination', function(coords, blipName, blipColor)
    SetCustomDestination(coords, blipName, blipColor)
end)

RegisterNetEvent('waypointIndicator:removeDestination')
AddEventHandler('waypointIndicator:removeDestination', function()
    RemoveCustomDestination()
end)
