local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local spawnLocationService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("spawn"):WaitForChild("GetSpawnLocationService"))

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local hrp = character:WaitForChild("HumanoidRootPart")
		local spawnPos = spawnLocationService.getSpawnLocation("cp1")

		-- Move the character to the spawn position
		hrp.CFrame = CFrame.new(spawnPos + Vector3.new(0, 3, 0))
	end)
end)
