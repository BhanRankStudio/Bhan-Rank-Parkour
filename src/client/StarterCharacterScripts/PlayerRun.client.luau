local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = script.Parent -- Script is parented to the character in StarterCharacterScripts
local humanoid = character:WaitForChild("Humanoid")

local DEFAULT_WALK_SPEED = 16 -- Default Roblox walk speed
local SPRINT_SPEED = 32 -- Adjust this value for desired sprint speed

-- Set initial speed just in case it's different
humanoid.WalkSpeed = DEFAULT_WALK_SPEED

local function onInputBegan(input, gameProcessedEvent)
	-- Ignore input if it's being used by the game engine (e.g., typing in chat)
	if gameProcessedEvent then
		return
	end

	if input.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = SPRINT_SPEED
	end
end

local function onInputEnded(input, gameProcessedEvent)
	-- No need to check gameProcessedEvent for InputEnded related to movement keys
	if input.KeyCode == Enum.KeyCode.LeftShift then
		humanoid.WalkSpeed = DEFAULT_WALK_SPEED
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)

-- Ensure walk speed resets if the character dies while sprinting
humanoid.Died:Connect(function()
	humanoid.WalkSpeed = DEFAULT_WALK_SPEED
end)
