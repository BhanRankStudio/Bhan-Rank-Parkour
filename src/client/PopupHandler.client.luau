local ReplicatedStorage = game:GetService("ReplicatedStorage")

local displayPopup = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("popup"):WaitForChild("DisplayPopup"))
local ShowWelcomePopup = ReplicatedStorage:WaitForChild("ShowWelcomePopup")

ShowWelcomePopup.OnClientEvent:Connect(function(message, title)
    displayPopup({
        title = title or "Welcome!",
        message = message,
        duration = 3
    })
end)
