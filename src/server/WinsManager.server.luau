local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

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

    -- Try to load saved wins from DataStore
    local success, data = pcall(function()
        return winsDataStore:GetAsync(player.UserId)
    end)

    if success and data then
        wins.Value = data
    else
        warn("Could not load wins for", player.Name)
    end
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
