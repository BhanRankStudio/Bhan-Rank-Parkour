local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Create or retrieve the RemoteEvent
local remoteName = "ShowWelcomePopup"
local remote = ReplicatedStorage:FindFirstChild(remoteName)

if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = remoteName
    remote.Parent = ReplicatedStorage
end

local PopupService = {}

function PopupService:SendToPlayer(player, message, title)
    remote:FireClient(player, message, title)
end

function PopupService:BroadcastToAll(message, title)
    for _, player in pairs(Players:GetPlayers()) do
        remote:FireClient(player, message, title)
    end
end

return PopupService
