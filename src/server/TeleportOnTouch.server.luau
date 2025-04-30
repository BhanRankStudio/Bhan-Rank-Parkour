local Players = game:GetService("Players")
local baseplate = workspace:WaitForChild("Baseplate")
local spawnLocation = workspace:WaitForChild("spawn"):WaitForChild("SpawnLocation")

baseplate.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = Players:GetPlayerFromCharacter(character)

	if player and character:FindFirstChild("HumanoidRootPart") then
		character:MoveTo(spawnLocation.Position + Vector3.new(0, 3, 0)) -- Slightly above to avoid falling through
	end
end)
