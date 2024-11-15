-- client.lua
local waypoint = nil
local lastWaypointStatus = false
local minDistance = 5.0
local heightOffset = 2.0
local GetWaypointCoords = GetWaypointCoords
local IsWaypointActive = IsWaypointActive
local GetEntityCoords = GetEntityCoords
local PlayerPedId = PlayerPedId
local GetScreenCoordFromWorldCoord = GetScreenCoordFromWorldCoord
local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord
local floor = math.floor
local vector3 = vector3

local cachedGroundZ = {}
local function GetCachedGroundZ(x, y)
    local key = string.format("%.1f%.1f", x, y)
    if not cachedGroundZ[key] then
        local ground, z = GetGroundZFor_3dCoord(x, y, 1000.0, true)
        if ground then
            cachedGroundZ[key] = z + heightOffset
        else
            cachedGroundZ[key] = 0.0
        end
    end
    return cachedGroundZ[key]
end

Citizen.CreateThread(function()
    while true do
        local isWaypointActive = IsWaypointActive()
        
        if isWaypointActive ~= lastWaypointStatus then
            if isWaypointActive then
                local waypointCoords = GetWaypointCoords()
                waypoint = vector3(waypointCoords.x, waypointCoords.y, GetCachedGroundZ(waypointCoords.x, waypointCoords.y))
            else
                waypoint = nil
                cachedGroundZ = {}
                SendNUIMessage({
                    type = "showIndicator",
                    show = false
                })
            end
            lastWaypointStatus = isWaypointActive
        end
        
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if waypoint then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - waypoint)
            local uiapp = GetUiappCurrentActivityByHash(`Map`)
                
            if distance > minDistance and uiapp == GetHashKey("Map") then
                local isVisible, screenX, screenY = GetScreenCoordFromWorldCoord(waypoint.x, waypoint.y, waypoint.z)
                
                if isVisible then
                    SendNUIMessage({
                        type = "update3DIndicator",
                        show = true,
                        x = screenX,
                        y = screenY,
                        distance = floor(distance)
                    })
                else
                    SendNUIMessage({
                        type = "showIndicator",
                        show = false
                    })
                end
                Citizen.Wait(0)
            else
                SendNUIMessage({
                    type = "showIndicator",
                    show = false
                })
                Citizen.Wait(100)
            end
        else
            Citizen.Wait(250)
        end
    end
end)
