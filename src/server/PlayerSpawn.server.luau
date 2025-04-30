local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpawnLocationService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("spawn"):WaitForChild("GetSpawnLocationService"))
local TeleportService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("checkpoint"):WaitForChild("TeleportService"))
local CheckpointService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("checkpoint"):WaitForChild("CheckpointService"))

-- Handle player joining and respawning
Players.PlayerAdded:Connect(function(player)
	-- Set default spawn location for player
	local defaultSpawnLocation = CheckpointService.getCheckPointBasePartInstance("cp3")
	player.RespawnLocation = defaultSpawnLocation
	
	-- Handle character spawning (both initial and respawn)
	player.CharacterAdded:Connect(function(_)
		task.wait(1) -- Wait for character to fully load
		TeleportService.teleportPlayerToCheckpoint(player)
	end)
end)
