local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local CheckpointRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("CheckpointRemote")
local resetEvent = CheckpointRemote:WaitForChild("ResetCheckpoint")
local getNameFunction = CheckpointRemote:WaitForChild("GetCheckpointName")
local updateUIEvent = CheckpointRemote:WaitForChild("UpdateUI")

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheckpointGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create a container frame for better organization
local container = Instance.new("Frame")
container.Name = "CheckpointContainer"
container.Size = UDim2.new(0, 220, 0, 130)
container.Position = UDim2.new(0, 20, 1, -150) -- Bottom left positioning
container.BackgroundTransparency = 1
container.Parent = screenGui

-- Create a stylish background with corner radius
local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
background.BackgroundTransparency = 0.2
background.BorderSizePixel = 0
background.Parent = container

-- Add rounded corners to background
local cornerRadius = Instance.new("UICorner")
cornerRadius.CornerRadius = UDim.new(0, 12)
cornerRadius.Parent = background

-- Add gradient effect
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
})
gradient.Rotation = 45
gradient.Parent = background

-- Add stroke/border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 80, 240)
stroke.Thickness = 1.5
stroke.Transparency = 0.5
stroke.Parent = background

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.4, 0, 0, 30) -- Reduced width to fit on same line
titleLabel.Position = UDim2.new(0, 10, 0, 20) -- Adjusted position for centered row
titleLabel.Text = "CHECKPOINT : "
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = container

-- Checkpoint value label
local label = Instance.new("TextLabel")
label.Name = "CheckpointLabel"
label.Size = UDim2.new(0.6, -20, 0, 30) -- Adjusted width to fill remaining space
label.Position = UDim2.new(0.6, 0, 0, 20) -- Positioned right after the title label
label.Text = "Loading..."
label.TextSize = 18
label.Font = Enum.Font.GothamSemibold
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.BackgroundTransparency = 1
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = container


-- Reset button
local button = Instance.new("TextButton")
button.Name = "ResetButton"
button.Size = UDim2.new(1, -40, 0, 36)
button.Position = UDim2.new(0.5, 0, 1, -46)
button.AnchorPoint = Vector2.new(0.5, 0)
button.Text = "Reset Checkpoint"
button.TextSize = 16
button.Font = Enum.Font.GothamBold
button.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
button.TextColor3 = Color3.new(1, 1, 1)
button.BorderSizePixel = 0
button.Parent = container

-- Add rounded corners to button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

-- Add hover effects for button
local originalColor = button.BackgroundColor3
button.MouseEnter:Connect(function()
    TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(230, 70, 90)}):Play()
end)

button.MouseLeave:Connect(function()
    TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = originalColor}):Play()
end)

-- Update label
local function updateCheckpoint()
    local name = getNameFunction:InvokeServer()
    label.Text = name or "None"
end

-- Connect to the UpdateUI event
updateUIEvent.OnClientEvent:Connect(updateCheckpoint)

-- Button click effect and functionality
button.MouseButton1Click:Connect(function()
    -- Animation effect
    local clickScale = TweenService:Create(
        button, 
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
        {Size = UDim2.new(1, -44, 0, 34)}
    )
    
    local releaseScale = TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, -40, 0, 36)}
    )
    
    clickScale:Play()
    clickScale.Completed:Connect(function()
        releaseScale:Play()
    end)
    
    resetEvent:FireServer()
    updateCheckpoint()
end)

-- Initial update and animation
container.Position = UDim2.new(0, -250, 1, -150) -- Start off-screen
TweenService:Create(container, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0, 20, 1, -150)
}):Play()

updateCheckpoint()
