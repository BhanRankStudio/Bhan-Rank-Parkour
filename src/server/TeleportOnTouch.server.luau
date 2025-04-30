local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("checkpoint"):WaitForChild("TeleportService"))
local baseplate = workspace:WaitForChild("Baseplate")

baseplate.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = Players:GetPlayerFromCharacter(character)

	if player and character:FindFirstChild("HumanoidRootPart") then
		TeleportService.teleportPlayerToCheckpoint(player)
	end
end)
