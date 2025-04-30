local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CheckpointService = require(script.Parent:WaitForChild("CheckpointService"))
local SpawnLocationService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("spawn"):WaitForChild("GetSpawnLocationService"))

local TeleportService = {}

function TeleportService.teleportPlayerToCheckpoint(player)
	local character = player.Character
	if not character then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local checkpointPos = CheckpointService.GetCheckpointPosition(player)
	if checkpointPos then
		character:MoveTo(checkpointPos + Vector3.new(0, 3, 0))
	else
		local spawnPos = SpawnLocationService.getSpawnLocation("SpawnLocation")
		if spawnPos then
			character:MoveTo(spawnPos + Vector3.new(0, 3, 0))
		else
			warn("No spawn location found!")
		end
	end
end

function TeleportService.teleportPlayerToDefaultSpawn(player)
	local character = player.Character
	if not character then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local spawnPos = SpawnLocationService.getSpawnLocation("SpawnLocation")
	if spawnPos then
		character:MoveTo(spawnPos + Vector3.new(0, 3, 0))
	else
		warn("No spawn location found!")
	end
end

return TeleportService
