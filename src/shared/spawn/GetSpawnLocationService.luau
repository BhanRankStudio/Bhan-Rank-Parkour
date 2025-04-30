--[[ 
    GetSpawnLocationService
    A service for finding spawn locations in the workspace
]]
local SpawnLocationService = {}

--[[
    Finds a SpawnLocation instance recursively by name
    @param parent - The parent instance to search in
    @param name - The name of the SpawnLocation to find
    @return The SpawnLocation instance if found, nil otherwise
]]
local function findSpawnLocation(parent: Instance, name: string): Instance?
    for _, child in ipairs(parent:GetDescendants()) do
        if child.Name == name and child:IsA("SpawnLocation") then
            return child
        end
    end
    return nil
end

--[[
    Gets the position of a spawn location by name
    @param spawnName - The name of the spawn location to find
    @return The position of the spawn location, or Vector3.new(0, 0, 0) if not found
]]
function SpawnLocationService.getSpawnLocation(spawnName: string): Vector3
    local spawnLocation = findSpawnLocation(workspace, spawnName)
    if spawnLocation then
        return spawnLocation.Position
    else
        warn("Spawn location not found or is not a SpawnLocation: " .. tostring(spawnName))
        return Vector3.new(0, 0, 0)
    end
end

--[[
    Gets the spawn location instance by name
    @param spawnName - The name of the spawn location to find
    @return The SpawnLocation instance if found, nil otherwise
]]
function SpawnLocationService.getSpawnLocationInstance(spawnName: string): Instance?
    local spawnLocation = findSpawnLocation(workspace, spawnName)
    if not spawnLocation then
        warn("Spawn location not found or is not a SpawnLocation: " .. tostring(spawnName))
    end
    
    return spawnLocation
end

return SpawnLocationService

