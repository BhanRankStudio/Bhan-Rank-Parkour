local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local checkpointStore = DataStoreService:GetDataStore("CheckpointData")
local CheckpointRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("CheckpointRemote")
local SpawnLocationService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("spawn"):WaitForChild("GetSpawnLocationService"))
local updateUIEvent = CheckpointRemote:WaitForChild("UpdateUI")

local resetEvent = CheckpointRemote:WaitForChild("ResetCheckpoint")
local getNameFunction = CheckpointRemote:WaitForChild("GetCheckpointName")

-- Handle checkpoint reset
resetEvent.OnServerEvent:Connect(function(player)
	local success, err = pcall(function()
		checkpointStore:RemoveAsync(tostring(player.UserId))
		-- kill the player to reset their position
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Health = 0 -- This will trigger the CharacterAdded event again
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
