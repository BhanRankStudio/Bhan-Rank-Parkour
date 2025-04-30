local ReplicatedStorage = game:GetService("ReplicatedStorage")


local PopupService = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("popup"):WaitForChild("PopupService"))

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    PopupService:SendToPlayer(player, "Welcome to Bhan Rank Parkour!", "Welcome!")
end)

task.delay(10, function()
    PopupService:BroadcastToAll("A new round is starting soon!", "Round Start")
end)
