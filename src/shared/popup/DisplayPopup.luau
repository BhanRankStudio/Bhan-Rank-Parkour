local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

local function displayPopup(options)
    -- Default options with modern settings
    local message = options.message or "No message"
    local title = options.title or nil
    local duration = options.duration or 3
    local theme = options.theme or "dark" -- dark or light
    local icon = options.icon -- optional icon image ID
    local buttonText = options.buttonText -- optional button text
    local callback = options.callback -- optional callback function for button
    local position = options.position or "center" -- center, top, bottom
    
    -- Create base GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernPopup"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Create main container
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 340, 0, title and 180 or 150)
    
    -- Position based on preference
    if position == "top" then
        container.Position = UDim2.new(0.5, -170, 0, -200)
    elseif position == "bottom" then
        container.Position = UDim2.new(0.5, -170, 1, 200)
    else -- center
        container.Position = UDim2.new(0.5, -170, 0.5, -90)
    end
    
    -- Theme colors
    local colors = {
        dark = {
            background = Color3.fromRGB(40, 42, 54),
            text = Color3.fromRGB(248, 248, 242),
            accent = Color3.fromRGB(80, 250, 123),
            shadow = Color3.fromRGB(30, 31, 40),
            button = Color3.fromRGB(68, 71, 90),
            buttonHover = Color3.fromRGB(88, 91, 112)
        },
        light = {
            background = Color3.fromRGB(245, 245, 245),
            text = Color3.fromRGB(50, 50, 50),
            accent = Color3.fromRGB(66, 135, 245),
            shadow = Color3.fromRGB(200, 200, 200),
            button = Color3.fromRGB(230, 230, 230),
            buttonHover = Color3.fromRGB(210, 210, 210)
        }
    }
    
    local themeColors = colors[theme]
    
    container.BackgroundColor3 = themeColors.background
    container.BorderSizePixel = 0
    container.BackgroundTransparency = 1
    container.Parent = screenGui
    
    -- Add glass effect and shadow
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = game:GetService("Lighting")
    
    -- Shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = themeColors.shadow
    shadow.ImageTransparency = 1
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.SliceScale = 1
    shadow.Parent = container
    
    -- Rounded corners
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = container
    
    -- Accent bar
    local accentBar = Instance.new("Frame")
    accentBar.Name = "AccentBar"
    accentBar.Size = UDim2.new(0, 6, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = themeColors.accent
    accentBar.BorderSizePixel = 0
    accentBar.BackgroundTransparency = 1
    accentBar.ZIndex = 2
    accentBar.Parent = container
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 12)
    accentCorner.Parent = accentBar
    
    -- Content area
    local contentPadding = 15
    local contentStartY = 20
    local contentWidth = container.Size.X.Offset - contentPadding * 2 - accentBar.Size.X.Offset - 5
    
    -- Icon (if provided)
    if icon then
        local iconImage = Instance.new("ImageLabel")
        iconImage.Name = "Icon"
        iconImage.Size = UDim2.new(0, 32, 0, 32)
        iconImage.Position = UDim2.new(0, contentPadding + accentBar.Size.X.Offset + 5, 0, contentStartY)
        iconImage.BackgroundTransparency = 1
        iconImage.Image = icon
        iconImage.ImageTransparency = 1
        iconImage.Parent = container
        
        contentStartY = contentStartY + 42
    end
    
    -- Title (if provided)
    if title then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "TitleLabel"
        titleLabel.Size = UDim2.new(0, contentWidth, 0, 28)
        titleLabel.Position = UDim2.new(0, contentPadding + accentBar.Size.X.Offset + 5, 0, contentStartY)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = themeColors.text
        titleLabel.TextSize = 22
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextWrapped = true
        titleLabel.TextTransparency = 1
        titleLabel.Parent = container
        
        contentStartY = contentStartY + 32
    end
    
    -- Message
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "MessageLabel"
    messageLabel.Size = UDim2.new(0, contentWidth, 0, 80)
    messageLabel.Position = UDim2.new(0, contentPadding + accentBar.Size.X.Offset + 5, 0, contentStartY)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = themeColors.text
    messageLabel.TextSize = 18
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.TextTransparency = 1
    messageLabel.Parent = container
    
    -- Add button if buttonText is provided
    local button
    if buttonText then
        button = Instance.new("TextButton")
        button.Name = "ActionButton"
        button.Size = UDim2.new(0, 100, 0, 36)
        button.Position = UDim2.new(1, -contentPadding - 100, 1, -contentPadding - 36)
        button.BackgroundColor3 = themeColors.button
        button.Text = buttonText
        button.TextColor3 = themeColors.text
        button.TextSize = 16
        button.Font = Enum.Font.GothamSemibold
        button.TextTransparency = 1
        button.BackgroundTransparency = 1
        button.AutoButtonColor = false
        button.Parent = container
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button
        
        -- Button hover effect
        local buttonHoverIn = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = themeColors.buttonHover})
        local buttonHoverOut = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = themeColors.button})
        
        button.MouseEnter:Connect(function()
            buttonHoverIn:Play()
        end)
        
        button.MouseLeave:Connect(function()
            buttonHoverOut:Play()
        end)
        
        button.MouseButton1Click:Connect(function()
            if callback and typeof(callback) == "function" then
                callback()
            end
            -- Begin closing animation early when button is clicked
            fadeOut()
        end)
    end
    
    -- Add pulse animation to accent bar
    local pulseAnimation = TweenService:Create(
        accentBar, 
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
        {BackgroundTransparency = 0.4}
    )
    
    -- Parent the ScreenGui
    screenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Animation functions
    local function fadeIn()
        -- Calculate target position based on preference
        local targetPosition
        if position == "top" then
            targetPosition = UDim2.new(0.5, -170, 0, 30)
        elseif position == "bottom" then
            targetPosition = UDim2.new(0.5, -170, 1, -210)
        else -- center
            targetPosition = UDim2.new(0.5, -170, 0.5, -90)
        end
        
        -- Prepare tweens
        local containerFade = TweenService:Create(
            container, 
            TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
            {BackgroundTransparency = 0, Position = targetPosition}
        )
        
        local shadowFade = TweenService:Create(
            shadow, 
            TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
            {ImageTransparency = 0.5}
        )
        
        local accentFade = TweenService:Create(
            accentBar, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
            {BackgroundTransparency = 0}
        )
        
        local messageFade = TweenService:Create(
            messageLabel, 
            TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, 0.1), 
            {TextTransparency = 0}
        )
        
        local blurTween = TweenService:Create(
            blur, 
            TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
            {Size = 10}
        )
        
        -- Play tweens
        containerFade:Play()
        shadowFade:Play()
        accentFade:Play()
        messageFade:Play()
        blurTween:Play()
        
        -- Title fade if exists
        if title then
            local titleFade = TweenService:Create(
                container:FindFirstChild("TitleLabel"), 
                TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, 0.05), 
                {TextTransparency = 0}
            )
            titleFade:Play()
        end
        
        -- Icon fade if exists
        if icon and container:FindFirstChild("Icon") then
            local iconFade = TweenService:Create(
                container:FindFirstChild("Icon"), 
                TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, 0.05), 
                {ImageTransparency = 0}
            )
            iconFade:Play()
        end
        
        -- Button fade if exists
        if button then
            local buttonFade = TweenService:Create(
                button, 
                TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, 0.15), 
                {TextTransparency = 0, BackgroundTransparency = 0}
            )
            buttonFade:Play()
        end
        
        -- Start accent pulse
        pulseAnimation:Play()
    end
    
    -- Global to allow button to trigger fadeOut early
    function fadeOut()
        -- Calculate exit position based on initial position
        local exitPosition
        if position == "top" then
            exitPosition = UDim2.new(0.5, -170, 0, -200)
        elseif position == "bottom" then
            exitPosition = UDim2.new(0.5, -170, 1, 200)
        else -- center
            exitPosition = UDim2.new(0.5, container.Size.X.Offset/2 * -1, 0.5, container.Size.Y.Offset/2 * -1)
        end
        
        -- Prepare tweens
        local containerFade = TweenService:Create(
            container, 
            TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
            {BackgroundTransparency = 1, Position = exitPosition}
        )
        
        local shadowFade = TweenService:Create(
            shadow, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
            {ImageTransparency = 1}
        )
        
        local accentFade = TweenService:Create(
            accentBar, 
            TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
            {BackgroundTransparency = 1}
        )
        
        local messageFade = TweenService:Create(
            messageLabel, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
            {TextTransparency = 1}
        )
        
        local blurTween = TweenService:Create(
            blur, 
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
            {Size = 0}
        )
        
        -- Title fade if exists
        if title then
            local titleFade = TweenService:Create(
                container:FindFirstChild("TitleLabel"), 
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
                {TextTransparency = 1}
            )
            titleFade:Play()
        end
        
        -- Icon fade if exists
        if icon and container:FindFirstChild("Icon") then
            local iconFade = TweenService:Create(
                container:FindFirstChild("Icon"), 
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
                {ImageTransparency = 1}
            )
            iconFade:Play()
        end
        
        -- Button fade if exists
        if button then
            local buttonFade = TweenService:Create(
                button, 
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), 
                {TextTransparency = 1, BackgroundTransparency = 1}
            )
            buttonFade:Play()
        end
        
        -- Stop pulse animation
        pulseAnimation:Cancel()
        
        -- Play tweens
        shadowFade:Play()
        accentFade:Play()
        messageFade:Play()
        blurTween:Play()
        containerFade:Play()
        
        -- Wait for animations to complete before cleanup
        task.delay(0.5, function()
            blur:Destroy()
            screenGui:Destroy()
        end)
    end
    
    -- Play intro animation
    fadeIn()
    
    -- Schedule automatic closing after duration
    task.delay(duration, fadeOut)
    
    -- Return the popup object to allow manual control
    return {
        close = fadeOut,
        container = container,
        screenGui = screenGui
    }
end

return displayPopup