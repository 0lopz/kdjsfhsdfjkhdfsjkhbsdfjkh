local VapeUI = {}

-- Default colors
local mainColor = Color3.fromRGB(40, 40, 45)
local accentColor = Color3.fromRGB(0, 150, 255)
local textColor = Color3.fromRGB(220, 220, 220)
local hoverColor = Color3.fromRGB(60, 60, 65)
local toggleOnColor = accentColor
local toggleOffColor = Color3.fromRGB(80, 80, 85)

-- Create rounded corners
local function createRoundCorners(instance, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(cornerRadius, 0)
    corner.Parent = instance
    return corner
end

-- Create stroke
local function createStroke(instance, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color or Color3.fromRGB(60, 60, 65)
    stroke.Parent = instance
    return stroke
end

-- Main window creation
function VapeUI:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VapeUI"
    screenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    mainFrame.BackgroundColor3 = mainColor
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Parent = screenGui
    
    createRoundCorners(mainFrame, 0.1)
    createStroke(mainFrame, 2)
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = mainColor
    titleBar.Parent = mainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -10, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "VapeUI"
    titleText.TextColor3 = textColor
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.Gotham
    titleText.TextSize = 14
    titleText.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 1, 0)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundColor3 = mainColor
    closeButton.Text = "X"
    closeButton.TextColor3 = textColor
    closeButton.Font = Enum.Font.Gotham
    closeButton.TextSize = 14
    closeButton.Parent = titleBar
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab system
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.Size = UDim2.new(1, 0, 0, 30)
    tabButtonsFrame.Position = UDim2.new(0, 0, 0, 30)
    tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tabButtonsFrame.Parent = mainFrame
    
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = "TabContent"
    tabContentFrame.Size = UDim2.new(1, -20, 1, -70)
    tabContentFrame.Position = UDim2.new(0, 10, 0, 70)
    tabContentFrame.BackgroundTransparency = 1
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
        tabButton.Size = UDim2.new(0, 70, 1, 0)
        tabButton.Position = UDim2.new(0, (#tabs * 70), 0, 0)
        tabButton.BackgroundColor3 = mainColor
        tabButton.Text = name
        tabButton.TextColor3 = textColor
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 12
        tabButton.Parent = tabButtonsFrame
        
        createRoundCorners(tabButton, 0.05)
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "TabContent"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
        tabContent.Visible = false
        tabContent.Parent = tabContentFrame
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Padding = UDim.new(0, 5)
        tabContentLayout.Parent = tabContent
        
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            tabContent.Visible = true
            currentTab = tabContent
        end)
        
        -- Select first tab by default
        if #tabs == 0 then
            tabContent.Visible = true
            currentTab = tabContent
        end
        
        table.insert(tabs, tabContent)
        
        local tabFunctions = {}
        
        function tabFunctions:CreateButton(name, callback)
            local button = Instance.new("TextButton")
            button.Name = name .. "Button"
            button.Size = UDim2.new(1, 0, 0, 30)
            button.BackgroundColor3 = mainColor
            button.Text = name
            button.TextColor3 = textColor
            button.Font = Enum.Font.Gotham
            button.TextSize = 12
            button.Parent = tabContent
            
            createRoundCorners(button, 0.05)
            createStroke(button, 1)
            
            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = hoverColor
            end)
            
            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = mainColor
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
            toggleFrame.Size = UDim2.new(1, 0, 0, 25)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent
            
            local toggleText = Instance.new("TextLabel")
            toggleText.Name = "ToggleText"
            toggleText.Size = UDim2.new(0.7, 0, 1, 0)
            toggleText.Position = UDim2.new(0, 0, 0, 0)
            toggleText.BackgroundTransparency = 1
            toggleText.Text = name
            toggleText.TextColor3 = textColor
            toggleText.TextXAlignment = Enum.TextXAlignment.Left
            toggleText.Font = Enum.Font.Gotham
            toggleText.TextSize = 12
            toggleText.Parent = toggleFrame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "ToggleButton"
            toggleButton.Size = UDim2.new(0.25, 0, 0.8, 0)
            toggleButton.Position = UDim2.new(0.75, 0, 0.1, 0)
            toggleButton.BackgroundColor3 = default and toggleOnColor or toggleOffColor
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            createRoundCorners(toggleButton, 0.2)
            createStroke(toggleButton, 1)
            
            local state = default or false
            
            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                toggleButton.BackgroundColor3 = state and toggleOnColor or toggleOffColor
                if callback then
                    callback(state)
                end
            end)
            
            local toggleFunctions = {}
            
            function toggleFunctions:SetValue(newState)
                state = newState
                toggleButton.BackgroundColor3 = state and toggleOnColor or toggleOffColor
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
            sliderFrame.Size = UDim2.new(1, 0, 0, 40)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent
            
            local sliderText = Instance.new("TextLabel")
            sliderText.Name = "SliderText"
            sliderText.Size = UDim2.new(1, 0, 0.5, 0)
            sliderText.Position = UDim2.new(0, 0, 0, 0)
            sliderText.BackgroundTransparency = 1
            sliderText.Text = name .. ": " .. default
            sliderText.TextColor3 = textColor
            sliderText.TextXAlignment = Enum.TextXAlignment.Left
            sliderText.Font = Enum.Font.Gotham
            sliderText.TextSize = 12
            sliderText.Parent = sliderFrame
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Name = "SliderBar"
            sliderBar.Size = UDim2.new(1, 0, 0.4, 0)
            sliderBar.Position = UDim2.new(0, 0, 0.6, 0)
            sliderBar.BackgroundColor3 = toggleOffColor
            sliderBar.Parent = sliderFrame
            
            createRoundCorners(sliderBar, 0.2)
            createStroke(sliderBar, 1)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "SliderFill"
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = accentColor
            sliderFill.Parent = sliderBar
            
            createRoundCorners(sliderFill, 0.2)
            
            local value = default or min
            local dragging = false
            
            local function updateSlider(input)
                local xScale = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                xScale = math.clamp(xScale, 0, 1)
                sliderFill.Size = UDim2.new(xScale, 0, 1, 0)
                value = math.floor(min + (max - min) * xScale)
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
                sliderFill.Size = UDim2.new(xScale, 0, 1, 0)
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
            dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.ClipsDescendants = true
            dropdownFrame.Parent = tabContent
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Name = "DropdownButton"
            dropdownButton.Size = UDim2.new(1, 0, 0, 30)
            dropdownButton.Position = UDim2.new(0, 0, 0, 0)
            dropdownButton.BackgroundColor3 = mainColor
            dropdownButton.Text = name .. ": " .. (default or options[1])
            dropdownButton.TextColor3 = textColor
            dropdownButton.Font = Enum.Font.Gotham
            dropdownButton.TextSize = 12
            dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
            dropdownButton.Parent = dropdownFrame
            
            createRoundCorners(dropdownButton, 0.05)
            createStroke(dropdownButton, 1)
            
            local dropdownArrow = Instance.new("TextLabel")
            dropdownArrow.Name = "DropdownArrow"
            dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            dropdownArrow.Position = UDim2.new(1, -20, 0, 0)
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Text = "▼"
            dropdownArrow.TextColor3 = textColor
            dropdownArrow.Font = Enum.Font.Gotham
            dropdownArrow.TextSize = 12
            dropdownArrow.Parent = dropdownButton
            
            local dropdownOptions = Instance.new("Frame")
            dropdownOptions.Name = "DropdownOptions"
            dropdownOptions.Size = UDim2.new(1, 0, 0, 0)
            dropdownOptions.Position = UDim2.new(0, 0, 0, 35)
            dropdownOptions.BackgroundColor3 = mainColor
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
                    dropdownOptions.Size = UDim2.new(1, 0, 0, #options * 25)
                    dropdownArrow.Text = "▲"
                else
                    dropdownOptions.Size = UDim2.new(1, 0, 0, 0)
                    dropdownArrow.Text = "▼"
                end
            end
            
            dropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = option .. "Option"
                optionButton.Size = UDim2.new(1, 0, 0, 25)
                optionButton.Position = UDim2.new(0, 0, 0, (i-1)*25)
                optionButton.BackgroundColor3 = mainColor
                optionButton.Text = option
                optionButton.TextColor3 = textColor
                optionButton.Font = Enum.Font.Gotham
                optionButton.TextSize = 12
                optionButton.TextXAlignment = Enum.TextXAlignment.Left
                optionButton.Parent = dropdownOptions
                
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

return VapeUI
