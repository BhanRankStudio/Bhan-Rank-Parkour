local DataStoreService = game:GetService("DataStoreService")
local Workspace = game:GetService("Workspace")

local checkpointStore = DataStoreService:GetDataStore("CheckpointData")
local checkpointsFolder = Workspace:WaitForChild("checkpoints")

-- Create the service table
local CheckpointService = {}

-- This table holds skip timestamps for players after a reset
CheckpointService.skipCheckpointUntil = {}

-- Save checkpoint
function CheckpointService.setCheckpoint(player, checkpointName)
	local success, err = pcall(function()
		checkpointStore:SetAsync(tostring(player.UserId), checkpointName)
	end)
	if success then
		print("Checkpoint saved for player " .. player.Name .. ": " .. checkpointName)
	else
		warn("Failed to save checkpoint: " .. tostring(err))
	end
end

-- Internal function to get checkpoint name
local function getCheckpointName(player)
	local success, checkpointName = pcall(function()
		return checkpointStore:GetAsync(tostring(player.UserId))
	end)
	if success and checkpointName then
		print("Loaded checkpoint for player " .. player.Name .. ": " .. checkpointName)
		return checkpointName
	else
		return nil
	end
end

-- Public function to get checkpoint position
function CheckpointService.GetCheckpointPosition(player)
	local checkpointName = getCheckpointName(player)

	if checkpointName then
		local checkpoint = checkpointsFolder:FindFirstChild(checkpointName)
		if checkpoint and checkpoint:IsA("Model") then
			local checkpointPart = checkpoint:FindFirstChild("cp")
			if checkpointPart and checkpointPart:IsA("BasePart") then
				return checkpointPart.Position + Vector3.new(0, 3, 0)
			end
		end
	end
	return nil
end

return CheckpointService
