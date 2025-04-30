local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local checkpointStore = DataStoreService:GetDataStore("CheckpointData")
local CheckpointRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("CheckpointRemote")
local updateUIEvent = CheckpointRemote:WaitForChild("UpdateUI")
local resetEvent = CheckpointRemote:WaitForChild("ResetCheckpoint")
local getNameFunction = CheckpointRemote:WaitForChild("GetCheckpointName")

local SpawnLocationService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("spawn"):WaitForChild("GetSpawnLocationService"))
local CheckpointService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("checkpoint"):WaitForChild("CheckpointService"))

-- Handle checkpoint reset
resetEvent.OnServerEvent:Connect(function(player)
	local success, err = pcall(function()
		checkpointStore:RemoveAsync(tostring(player.UserId))

		-- Prevent checkpoint from being immediately re-set
		CheckpointService.skipCheckpointUntil[player.UserId] = tick() + 2

		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Health = 0 -- Will respawn at RespawnLocation
			player.RespawnLocation = SpawnLocationService.getSpawnLocationInstance("SpawnLocation")
			updateUIEvent:FireClient(player, "Checkpoint reset to spawn location.")
		end
	end)
	if not success then
		warn("Failed to reset checkpoint for " .. player.Name .. ": " .. tostring(err))
	end
end)

-- Handle checkpoint name request
getNameFunction.OnServerInvoke = function(player)
	local success, result = pcall(function()
		return checkpointStore:GetAsync(tostring(player.UserId))
	end)
	if success then
		return result or "None"
	else
		warn("Error getting checkpoint for " .. player.Name .. ": " .. tostring(result))
		return "Error"
	end
end
