print("Checkpoint server script loaded")

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CheckpointService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("checkpoint"):WaitForChild("CheckpointService"))

-- Create or get a remote event for UI updates
local CheckpointRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("CheckpointRemote")
local updateUIEvent = CheckpointRemote:FindFirstChild("UpdateUI") or Instance.new("RemoteEvent")
updateUIEvent.Name = "UpdateUI"
updateUIEvent.Parent = CheckpointRemote

local checkpointsFolder = Workspace:WaitForChild("checkpoints")

-- Debounce table to track last checkpoint touched per player
local lastTouchedCheckpoint = {}
local skipCheckpointUntil = CheckpointService.skipCheckpointUntil

-- Time threshold to ignore repeated touches (in seconds)
local DEBOUNCE_TIME = 1.5

for _, checkpointModel in pairs(checkpointsFolder:GetChildren()) do
	if checkpointModel:IsA("Model") then
		local checkpointPart = checkpointModel:FindFirstChild("cp")
		if checkpointPart and checkpointPart:IsA("BasePart") then
			checkpointPart.Touched:Connect(function(hit)
				local character = hit.Parent
				local player = Players:GetPlayerFromCharacter(character)
				if player then
					local now = tick()

					-- Prevent saving checkpoint if just reset
					if skipCheckpointUntil[player.UserId] and now < skipCheckpointUntil[player.UserId] then
						return
					end

					local lastTime = lastTouchedCheckpoint[player.UserId] or 0
					if now - lastTime > DEBOUNCE_TIME then
						lastTouchedCheckpoint[player.UserId] = now
						CheckpointService.setCheckpoint(player, checkpointModel.Name)
						updateUIEvent:FireClient(player)
						print(player.Name .. " touched checkpoint: " .. checkpointModel.Name)
					end
				end
			end)
		end
	end
end
