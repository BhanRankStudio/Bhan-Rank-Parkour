local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local winsDataStore = DataStoreService:GetDataStore("PlayerWins") -- persistent

-- When player joins the game
Players.PlayerAdded:Connect(function(player)
    -- Set up leaderboard (leaderstats)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local wins = Instance.new("IntValue")
    wins.Name = "Wins"
    wins.Value = 0
    wins.Parent = leaderstats

    local height = Instance.new("IntValue")
    height.Name = "Height"
    height.Value = 0
    height.Parent = leaderstats

    -- Try to load saved wins from DataStore
    local success, data = pcall(function()
        return winsDataStore:GetAsync(player.UserId)
    end)

    if success and data then
        wins.Value = data
    else
        warn("Could not load wins for", player.Name)
    end

    -- Update the height value in real-time using RunService.Heartbeat
    local function updateHeight()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        RunService.Heartbeat:Connect(function()
            if humanoidRootPart then
                local currentHeight = humanoidRootPart.Position.Y
                height.Value = math.floor(currentHeight - 0.5) -- Adjust the height value as needed
            end
        end)
    end

    -- Call updateHeight when the player's character spawns
    if player.Character then
        updateHeight()
    end
    player.CharacterAdded:Connect(updateHeight)
end)

-- Save the player's wins when they leave
Players.PlayerRemoving:Connect(function(player)
    local wins = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Wins")
    if wins then
        local success, err = pcall(function()
            winsDataStore:SetAsync(player.UserId, wins.Value)
        end)
        if not success then
            warn("Failed to save wins for", player.Name, err)
        end
    end
end)
