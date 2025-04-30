local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpawnLocationService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("spawn"):WaitForChild("GetSpawnLocationService"))
local TeleportService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("checkpoint"):WaitForChild("TeleportService"))

-- Teleport player when they join or respawn
Players.PlayerAdded:Connect(function(player)
	local defaultSpawnLocation = SpawnLocationService.getSpawnLocationInstance("SpawnLocation")
	player.RespawnLocation = defaultSpawnLocation
	task.wait(3)
	TeleportService.teleportPlayerToCheckpoint(player)
end)
