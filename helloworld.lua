-- Modern Sleek Dark UI Library for Roblox
local ModernUI = {}

-- Color palette
local colors = {
    background = Color3.fromRGB(28, 28, 32),
    secondary = Color3.fromRGB(40, 40, 45),
    accent = Color3.fromRGB(0, 180, 255),
    text = Color3.fromRGB(240, 240, 240),
    textSecondary = Color3.fromRGB(180, 180, 180),
    hover = Color3.fromRGB(50, 50, 55),
    toggleOn = Color3.fromRGB(0, 200, 100),
    toggleOff = Color3.fromRGB(70, 70, 75),
    stroke = Color3.fromRGB(60, 60, 65),
    checkmark = Color3.fromRGB(255, 255, 255)
}

-- Animation service
local tweenService = game:GetService("TweenService")

-- Animation settings
local tweenInfo = TweenInfo.new(
    0.15, -- Time
    Enum.EasingStyle.Quad, -- EasingStyle
    Enum.EasingDirection.Out -- EasingDirection
)

-- Create rounded corners
local function createRoundCorners(instance, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(cornerRadius, 0)
    corner.Parent = instance
    return corner
end

-- Create stroke
local function createStroke(instance, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color or colors.stroke
    stroke.Transparency = transparency or 0
    stroke.Parent = instance
    return stroke
end

-- Create padding
local function createPadding(instance, padding)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, padding)
    pad.PaddingRight = UDim.new(0, padding)
    pad.PaddingTop = UDim.new(0, padding)
    pad.PaddingBottom = UDim.new(0, padding)
    pad.Parent = instance
    return pad
end

-- Main window creation
function ModernUI:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Parent = screenGui
    
    createRoundCorners(mainFrame, 0.08)
    createStroke(mainFrame, 2)
    
    -- Shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 36)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = colors.secondary
    titleBar.Parent = mainFrame
    
    createRoundCorners(titleBar, 0.08, true)
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 12, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "Modern UI"
    titleText.TextColor3 = colors.text
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamSemibold
    titleText.TextSize = 14
    titleText.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 36, 0, 36)
    closeButton.Position = UDim2.new(1, -36, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Image = "rbxassetid://3926305904"
    closeButton.ImageColor3 = colors.textSecondary
    closeButton.ImageRectOffset = Vector2.new(284, 4)
    closeButton.ImageRectSize = Vector2.new(24, 24)
    closeButton.Parent = titleBar
    
    closeButton.MouseEnter:Connect(function()
        tweenService:Create(closeButton, tweenInfo, {ImageColor3 = colors.text}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        tweenService:Create(closeButton, tweenInfo, {ImageColor3 = colors.textSecondary}):Play()
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab system
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.Size = UDim2.new(1, 0, 0, 36)
    tabButtonsFrame.Position = UDim2.new(0, 0, 0, 36)
    tabButtonsFrame.BackgroundColor3 = colors.secondary
    tabButtonsFrame.Parent = mainFrame
    
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = "TabContent"
    tabContentFrame.Size = UDim2.new(1, -20, 1, -88)
    tabContentFrame.Position = UDim2.new(0, 10, 0, 88)
    tabContentFrame.BackgroundTransparency = 1
    tabContentFrame.ClipsDescendants = true
    tabContentFrame.Parent = mainFrame
    
    local tabs = {}
    local currentTab = nil
    
    -- Make draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    function tabs:CreateTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "TabButton"
        tabButton.Size = UDim2.new(0, 80, 1, 0)
        tabButton.Position = UDim2.new(0, (#tabs * 80), 0, 0)
        tabButton.BackgroundColor3 = colors.secondary
        tabButton.BackgroundTransparency = 1
        tabButton.Text = name
        tabButton.TextColor3 = colors.textSecondary
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 12
        tabButton.Parent = tabButtonsFrame
        
        local underline = Instance.new("Frame")
        underline.Name = "Underline"
        underline.Size = UDim2.new(0.6, 0, 0, 2)
        underline.Position = UDim2.new(0.2, 0, 1, -2)
        underline.BackgroundColor3 = colors.accent
        underline.BackgroundTransparency = 1
        underline.Parent = tabButton
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "TabContent"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = colors.stroke
        tabContent.Visible = false
        tabContent.Parent = tabContentFrame
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Padding = UDim.new(0, 8)
        tabContentLayout.Parent = tabContent
        
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
                for _, btn in ipairs(tabButtonsFrame:GetChildren()) do
                    if btn:IsA("TextButton") then
                        tweenService:Create(btn, tweenInfo, {TextColor3 = colors.textSecondary}):Play()
                        tweenService:Create(btn.Underline, tweenInfo, {BackgroundTransparency = 1}):Play()
                    end
                end
            end
            
            tweenService:Create(tabButton, tweenInfo, {TextColor3 = colors.text}):Play()
            tweenService:Create(tabButton.Underline, tweenInfo, {BackgroundTransparency = 0}):Play()
            
            tabContent.Visible = true
            currentTab = tabContent
        end)
        
        -- Select first tab by default
        if #tabs == 0 then
            tabContent.Visible = true
            currentTab = tabContent
            tabButton.TextColor3 = colors.text
            underline.BackgroundTransparency = 0
        end
        
        table.insert(tabs, tabContent)
        
        local tabFunctions = {}
        
        function tabFunctions:CreateSection(name)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name .. "Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 30)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Parent = tabContent
            
            local sectionText = Instance.new("TextLabel")
            sectionText.Name = "SectionText"
            sectionText.Size = UDim2.new(1, 0, 1, 0)
            sectionText.Position = UDim2.new(0, 0, 0, 0)
            sectionText.BackgroundTransparency = 1
            sectionText.Text = string.upper(name)
            sectionText.TextColor3 = colors.textSecondary
            sectionText.TextXAlignment = Enum.TextXAlignment.Left
            sectionText.Font = Enum.Font.Gotham
            sectionText.TextSize = 11
            sectionText.Parent = sectionFrame
            
            return sectionFrame
        end
        
        function tabFunctions:CreateButton(name, callback)
            local button = Instance.new("TextButton")
            button.Name = name .. "Button"
            button.Size = UDim2.new(1, 0, 0, 32)
            button.BackgroundColor3 = colors.secondary
            button.Text = name
            button.TextColor3 = colors.text
            button.Font = Enum.Font.Gotham
            button.TextSize = 12
            button.Parent = tabContent
            
            createRoundCorners(button, 0.05)
            createStroke(button, 1)
            
            button.MouseEnter:Connect(function()
                tweenService:Create(button, tweenInfo, {BackgroundColor3 = colors.hover}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                tweenService:Create(button, tweenInfo, {BackgroundColor3 = colors.secondary}):Play()
            end)
            
            button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
            
            return button
        end
        
        function tabFunctions:CreateToggle(name, default, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = name .. "Toggle"
            toggleFrame.Size = UDim2.new(1, 0, 0, 28)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent
            
            local toggleText = Instance.new("TextLabel")
            toggleText.Name = "ToggleText"
            toggleText.Size = UDim2.new(0.7, 0, 1, 0)
            toggleText.Position = UDim2.new(0, 0, 0, 0)
            toggleText.BackgroundTransparency = 1
            toggleText.Text = name
            toggleText.TextColor3 = colors.text
            toggleText.TextXAlignment = Enum.TextXAlignment.Left
            toggleText.Font = Enum.Font.Gotham
            toggleText.TextSize = 12
            toggleText.Parent = toggleFrame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "ToggleButton"
            toggleButton.Size = UDim2.new(0, 44, 0, 24)
            toggleButton.Position = UDim2.new(1, -44, 0.5, -12)
            toggleButton.BackgroundColor3 = default and colors.toggleOn or colors.toggleOff
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            createRoundCorners(toggleButton, 0.5)
            createStroke(toggleButton, 1)
            
            -- Checkmark icon
            local checkmark = Instance.new("ImageLabel")
            checkmark.Name = "Checkmark"
            checkmark.Size = UDim2.new(0, 16, 0, 16)
            checkmark.Position = UDim2.new(0.5, -8, 0.5, -8)
            checkmark.BackgroundTransparency = 1
            checkmark.Image = "rbxassetid://3926305904"
            checkmark.ImageColor3 = colors.checkmark
            checkmark.ImageRectOffset = Vector2.new(124, 204)
            checkmark.ImageRectSize = Vector2.new(16, 16)
            checkmark.Parent = toggleButton
            checkmark.Visible = default
            
            local state = default or false
            
            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                
                if state then
                    tweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = colors.toggleOn}):Play()
                    checkmark.Visible = true
                    checkmark.ImageTransparency = 1
                    tweenService:Create(checkmark, tweenInfo, {ImageTransparency = 0}):Play()
                else
                    tweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = colors.toggleOff}):Play()
                    tweenService:Create(checkmark, tweenInfo, {ImageTransparency = 1}):Play()
                end
                
                if callback then
                    callback(state)
                end
            end)
            
            local toggleFunctions = {}
            
            function toggleFunctions:SetValue(newState)
                state = newState
                
                if state then
                    toggleButton.BackgroundColor3 = colors.toggleOn
                    checkmark.Visible = true
                    checkmark.ImageTransparency = 0
                else
                    toggleButton.BackgroundColor3 = colors.toggleOff
                    checkmark.ImageTransparency = 1
                end
                
                if callback then
                    callback(state)
                end
            end
            
            function toggleFunctions:GetValue()
                return state
            end
            
            return toggleFunctions
        end
        
        function tabFunctions:CreateSlider(name, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = name .. "Slider"
            sliderFrame.Size = UDim2.new(1, 0, 0, 48)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent
            
            local sliderText = Instance.new("TextLabel")
            sliderText.Name = "SliderText"
            sliderText.Size = UDim2.new(1, 0, 0, 16)
            sliderText.Position = UDim2.new(0, 0, 0, 0)
            sliderText.BackgroundTransparency = 1
            sliderText.Text = name .. ": " .. default
            sliderText.TextColor3 = colors.text
            sliderText.TextXAlignment = Enum.TextXAlignment.Left
            sliderText.Font = Enum.Font.Gotham
            sliderText.TextSize = 12
            sliderText.Parent = sliderFrame
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Name = "SliderBar"
            sliderBar.Size = UDim2.new(1, 0, 0, 6)
            sliderBar.Position = UDim2.new(0, 0, 0, 24)
            sliderBar.BackgroundColor3 = colors.toggleOff
            sliderBar.Parent = sliderFrame
            
            createRoundCorners(sliderBar, 0.5)
            createStroke(sliderBar, 1)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "SliderFill"
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = colors.accent
            sliderFill.Parent = sliderBar
            
            createRoundCorners(sliderFill, 0.5)
            
            local sliderHandle = Instance.new("Frame")
            sliderHandle.Name = "SliderHandle"
            sliderHandle.Size = UDim2.new(0, 12, 0, 12)
            sliderHandle.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
            sliderHandle.BackgroundColor3 = colors.text
            sliderHandle.Parent = sliderBar
            
            createRoundCorners(sliderHandle, 0.5)
            createStroke(sliderHandle, 1, colors.stroke)
            
            local value = default or min
            local dragging = false
            
            local function updateSlider(input)
                local xScale = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                xScale = math.clamp(xScale, 0, 1)
                
                tweenService:Create(sliderFill, tweenInfo, {Size = UDim2.new(xScale, 0, 1, 0)}):Play()
                tweenService:Create(sliderHandle, tweenInfo, {Position = UDim2.new(xScale, -6, 0.5, -6)}):Play()
                
                value = math.floor(min + (max - min) * xScale + 0.5)
                sliderText.Text = name .. ": " .. value
                
                if callback then
                    callback(value)
                end
            end
            
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            sliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            sliderBar.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            local sliderFunctions = {}
            
            function sliderFunctions:SetValue(newValue)
                value = math.clamp(newValue, min, max)
                local xScale = (value - min) / (max - min)
                
                tweenService:Create(sliderFill, tweenInfo, {Size = UDim2.new(xScale, 0, 1, 0)}):Play()
                tweenService:Create(sliderHandle, tweenInfo, {Position = UDim2.new(xScale, -6, 0.5, -6)}):Play()
                
                sliderText.Text = name .. ": " .. value
                
                if callback then
                    callback(value)
                end
            end
            
            function sliderFunctions:GetValue()
                return value
            end
            
            return sliderFunctions
        end
        
        function tabFunctions:CreateDropdown(name, options, default, callback)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = name .. "Dropdown"
            dropdownFrame.Size = UDim2.new(1, 0, 0, 32)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.ClipsDescendants = true
            dropdownFrame.Parent = tabContent
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Name = "DropdownButton"
            dropdownButton.Size = UDim2.new(1, 0, 0, 32)
            dropdownButton.Position = UDim2.new(0, 0, 0, 0)
            dropdownButton.BackgroundColor3 = colors.secondary
            dropdownButton.Text = name .. ": " .. (default or options[1])
            dropdownButton.TextColor3 = colors.text
            dropdownButton.Font = Enum.Font.Gotham
            dropdownButton.TextSize = 12
            dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
            dropdownButton.Parent = dropdownFrame
            
            createRoundCorners(dropdownButton, 0.05)
            createStroke(dropdownButton, 1)
            createPadding(dropdownButton, 8)
            
            local dropdownArrow = Instance.new("ImageLabel")
            dropdownArrow.Name = "DropdownArrow"
            dropdownArrow.Size = UDim2.new(0, 16, 0, 16)
            dropdownArrow.Position = UDim2.new(1, -24, 0.5, -8)
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Image = "rbxassetid://3926305904"
            dropdownArrow.ImageColor3 = colors.text
            dropdownArrow.ImageRectOffset = Vector2.new(284, 4)
            dropdownArrow.ImageRectSize = Vector2.new(24, 24)
            dropdownArrow.Rotation = 180
            dropdownArrow.Parent = dropdownButton
            
            local dropdownOptions = Instance.new("Frame")
            dropdownOptions.Name = "DropdownOptions"
            dropdownOptions.Size = UDim2.new(1, 0, 0, 0)
            dropdownOptions.Position = UDim2.new(0, 0, 0, 36)
            dropdownOptions.BackgroundColor3 = colors.secondary
            dropdownOptions.Parent = dropdownFrame
            
            createRoundCorners(dropdownOptions, 0.05)
            createStroke(dropdownOptions, 1)
            
            local optionsList = Instance.new("UIListLayout")
            optionsList.Parent = dropdownOptions
            
            local isOpen = false
            local selected = default or options[1]
            
            local function toggleDropdown()
                isOpen = not isOpen
                if isOpen then
                    tweenService:Create(dropdownOptions, tweenInfo, {Size = UDim2.new(1, 0, 0, math.min(#options * 32, 160))}):Play()
                    tweenService:Create(dropdownArrow, tweenInfo, {Rotation = 0}):Play()
                else
                    tweenService:Create(dropdownOptions, tweenInfo, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    tweenService:Create(dropdownArrow, tweenInfo, {Rotation = 180}):Play()
                end
            end
            
            dropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = option .. "Option"
                optionButton.Size = UDim2.new(1, 0, 0, 32)
                optionButton.Position = UDim2.new(0, 0, 0, (i-1)*32)
                optionButton.BackgroundColor3 = colors.secondary
                optionButton.Text = option
                optionButton.TextColor3 = colors.text
                optionButton.Font = Enum.Font.Gotham
                optionButton.TextSize = 12
                optionButton.TextXAlignment = Enum.TextXAlignment.Left
                optionButton.Parent = dropdownOptions
                
                createPadding(optionButton, 8)
                
                optionButton.MouseEnter:Connect(function()
                    tweenService:Create(optionButton, tweenInfo, {BackgroundColor3 = colors.hover}):Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    tweenService:Create(optionButton, tweenInfo, {BackgroundColor3 = colors.secondary}):Play()
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    selected = option
                    dropdownButton.Text = name .. ": " .. selected
                    toggleDropdown()
                    if callback then
                        callback(selected)
                    end
                end)
            end
            
            local dropdownFunctions = {}
            
            function dropdownFunctions:SetValue(newValue)
                if table.find(options, newValue) then
                    selected = newValue
                    dropdownButton.Text = name .. ": " .. selected
                    if callback then
                        callback(selected)
                    end
                end
            end
            
            function dropdownFunctions:GetValue()
                return selected
            end
            
            return dropdownFunctions
        end
        
        return tabFunctions
    end
    
    return tabs
end

return ModernUI
