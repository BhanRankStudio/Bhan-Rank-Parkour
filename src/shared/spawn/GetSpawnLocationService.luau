local SpawnLocationService = {}

function SpawnLocationService.getSpawnLocation(spawnName: string): Vector3
	local function findRecursive(parent, name)
		for _, child in ipairs(parent:GetDescendants()) do
			if child.Name == name and child:IsA("SpawnLocation") then
				return child
			end
		end
		return nil
	end

	local spawnLocation = findRecursive(workspace, spawnName)
	if spawnLocation then
		return spawnLocation.Position
	else
		warn("Spawn location not found or is not a SpawnLocation: " .. tostring(spawnName))
		return Vector3.new(0, 0, 0)
	end
end

return SpawnLocationService

