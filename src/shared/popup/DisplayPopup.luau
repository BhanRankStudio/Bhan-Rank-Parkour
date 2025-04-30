local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function displayPopup(options)
    local message = options.message or "No message"
    local title = options.title or nil
    local duration = options.duration or 3

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomPopup"
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    if title then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 40)
        titleLabel.Position = UDim2.new(0, 10, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 22
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextWrapped = true
        titleLabel.TextTransparency = 1
        titleLabel.Parent = frame
    end

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 80)
    messageLabel.Position = title and UDim2.new(0, 10, 0, 55) or UDim2.new(0, 10, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.TextSize = 20
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextWrapped = true
    messageLabel.TextTransparency = 1
    messageLabel.Parent = frame

    screenGui.Parent = Player:WaitForChild("PlayerGui")

    for i = 1, 10 do
        frame.BackgroundTransparency = 1 - (i / 10 * 0.8)
        messageLabel.TextTransparency = 1 - (i / 10)
        if title then
            frame:FindFirstChildOfClass("TextLabel").TextTransparency = 1 - (i / 10)
        end
        task.wait(0.03)
    end

    task.wait(duration)

    for i = 1, 10 do
        frame.BackgroundTransparency = 0.2 + (i / 10 * 0.8)
        messageLabel.TextTransparency = i / 10
        if title then
            frame:FindFirstChildOfClass("TextLabel").TextTransparency = i / 10
        end
        task.wait(0.03)
    end

    screenGui:Destroy()
end

return displayPopup
