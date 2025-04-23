-- Minecraft UI Library v1.0
-- Inspired by RISE v4

local MinecraftUI = {}
MinecraftUI.__index = MinecraftUI

-- Font setup
local function loadMinecraftFont()
    local font = Instance.new("Font")
    font.Family = "rbxasset://fonts/families/Inconsolata.json"
    return font
end

-- Colors
local colors = {
    background = Color3.fromRGB(42, 42, 42),
    button = Color3.fromRGB(85, 85, 85),
    buttonHover = Color3.fromRGB(105, 105, 105),
    buttonText = Color3.fromRGB(255, 255, 255),
    slider = Color3.fromRGB(100, 100, 100),
    sliderFill = Color3.fromRGB(0, 150, 0),
    dropdown = Color3.fromRGB(65, 65, 65),
    dropdownHover = Color3.fromRGB(85, 85, 85),
    dropdownText = Color3.fromRGB(255, 255, 255),
    tab = Color3.fromRGB(60, 60, 60),
    tabActive = Color3.fromRGB(85, 85, 85),
    tabText = Color3.fromRGB(255, 255, 255),
    window = Color3.fromRGB(50, 50, 50),
    windowBorder = Color3.fromRGB(20, 20, 20),
    text = Color3.fromRGB(255, 255, 255),
    toggleOff = Color3.fromRGB(100, 100, 100),
    toggleOn = Color3.fromRGB(0, 150, 0),
    toggleKnob = Color3.fromRGB(200, 200, 200)
}

-- Utility functions
local function createFrame(parent, size, position, color, transparency)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = transparency or 0
    frame.BorderSizePixel = 0
    frame.Parent = parent
    return frame
end

local function createTextLabel(parent, text, size, position, color)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or colors.text
    label.Font = loadMinecraftFont()
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function createTextBox(parent, text, size, position)
    local box = Instance.new("TextBox")
    box.Size = size
    box.Position = position
    box.BackgroundColor3 = colors.dropdown
    box.TextColor3 = colors.text
    box.Font = loadMinecraftFont()
    box.TextSize = 14
    box.Text = text
    box.Parent = parent
    return box
end

-- Main Window
function MinecraftUI:CreateWindow(title)
    local window = {}
    setmetatable(window, MinecraftUI)
    
    -- Main screen gui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MinecraftUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Main window frame
    local mainFrame = createFrame(screenGui, UDim2.new(0, 400, 0, 300), UDim2.new(0.5, -200, 0.5, -150), colors.window)
    mainFrame.Name = "MainWindow"
    
    -- Window title bar
    local titleBar = createFrame(mainFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 0), colors.windowBorder)
    local titleText = createTextLabel(titleBar, title, UDim2.new(1, -10, 1, 0), UDim2.new(0, 5, 0, 0))
    
    -- Tab container
    local tabContainer = createFrame(mainFrame, UDim2.new(1, -10, 0, 30), UDim2.new(0, 5, 0, 25), colors.window)
    tabContainer.Name = "TabContainer"
    
    -- Content frame
    local contentFrame = createFrame(mainFrame, UDim2.new(1, -10, 1, -60), UDim2.new(0, 5, 0, 55), colors.window)
    contentFrame.Name = "ContentFrame"
    contentFrame.ClipsDescendants = true
    
    -- Store references
    window.screenGui = screenGui
    window.mainFrame = mainFrame
    window.tabContainer = tabContainer
    window.contentFrame = contentFrame
    window.tabs = {}
    window.currentTab = nil
    
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
    
    return window
end

-- Tabs
function MinecraftUI:CreateTab(name)
    local tab = {}
    tab.name = name
    tab.buttons = {}
    
    -- Tab button
    local tabButton = createFrame(self.tabContainer, UDim2.new(0, 80, 1, 0), UDim2.new(0, #self.tabs * 82, 0, 0), colors.tab)
    local tabText = createTextLabel(tabButton, name, UDim2.new(1, 0, 1, 0), UDim2.new(0, 5, 0, 0))
    
    -- Tab content
    local tabContent = createFrame(self.contentFrame, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), colors.window)
    tabContent.Visible = false
    tabContent.Name = name .. "Content"
    
    -- Store references
    tab.button = tabButton
    tab.content = tabContent
    tab.buttonText = tabText
    
    -- Click handler
    tabButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:SwitchTab(tab)
        end
    end)
    
    -- Add to window
    table.insert(self.tabs, tab)
    
    -- If first tab, make it active
    if #self.tabs == 1 then
        self:SwitchTab(tab)
    end
    
    return tab
end

function MinecraftUI:SwitchTab(tab)
    -- Hide all tab contents
    for _, t in ipairs(self.tabs) do
        t.content.Visible = false
        t.button.BackgroundColor3 = colors.tab
    end
    
    -- Show selected tab content
    tab.content.Visible = true
    tab.button.BackgroundColor3 = colors.tabActive
    
    self.currentTab = tab
end

-- Buttons
function MinecraftUI:CreateButton(tab, text, callback)
    local button = {}
    
    -- Calculate position based on existing buttons
    local yPos = #tab.buttons * 30 + 10
    
    -- Button frame
    local buttonFrame = createFrame(tab.content, UDim2.new(1, -20, 0, 25), UDim2.new(0, 10, 0, yPos), colors.button)
    local buttonText = createTextLabel(buttonFrame, text, UDim2.new(1, -10, 1, 0), UDim2.new(0, 5, 0, 0), colors.buttonText)
    
    -- Hover effects
    buttonFrame.MouseEnter:Connect(function()
        buttonFrame.BackgroundColor3 = colors.buttonHover
    end)
    
    buttonFrame.MouseLeave:Connect(function()
        buttonFrame.BackgroundColor3 = colors.button
    end)
    
    -- Click handler
    buttonFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if callback then
                callback()
            end
        end
    end)
    
    -- Store reference
    button.frame = buttonFrame
    table.insert(tab.buttons, button)
    
    return button
end

-- Toggles
function MinecraftUI:CreateToggle(tab, text, default, callback)
    local toggle = {}
    toggle.value = default or false
    
    -- Calculate position
    local yPos = #tab.buttons * 30 + 10
    
    -- Toggle frame
    local toggleFrame = createFrame(tab.content, UDim2.new(1, -20, 0, 25), UDim2.new(0, 10, 0, yPos), colors.window)
    toggleFrame.BackgroundTransparency = 1
    
    -- Toggle text
    local toggleText = createTextLabel(toggleFrame, text, UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    
    -- Toggle background
    local toggleBg = createFrame(toggleFrame, UDim2.new(0, 40, 0, 20), UDim2.new(0.7, 0, 0.5, -10), toggle.value and colors.toggleOn or colors.toggleOff)
    toggleBg.Name = "ToggleBg"
    
    -- Toggle knob
    local toggleKnob = createFrame(toggleBg, UDim2.new(0, 18, 1, -4), UDim2.new(toggle.value and 1 or 0, toggle.value and -18 or 2, 0, 2), colors.toggleKnob)
    toggleKnob.Name = "ToggleKnob"
    
    -- Click handler
    toggleBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle.value = not toggle.value
            
            -- Animate toggle
            local tween = game:GetService("TweenService"):Create(
                toggleKnob,
                TweenInfo.new(0.1),
                {Position = UDim2.new(toggle.value and 1 or 0, toggle.value and -18 or 2, 0, 2)}
            )
            tween:Play()
            
            toggleBg.BackgroundColor3 = toggle.value and colors.toggleOn or colors.toggleOff
            
            if callback then
                callback(toggle.value)
            end
        end
    end)
    
    -- Hover effects
    toggleBg.MouseEnter:Connect(function()
        toggleBg.BackgroundColor3 = toggle.value and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(120, 120, 120)
    end)
    
    toggleBg.MouseLeave:Connect(function()
        toggleBg.BackgroundColor3 = toggle.value and colors.toggleOn or colors.toggleOff
    end)
    
    -- Store reference
    toggle.frame = toggleFrame
    table.insert(tab.buttons, toggle)
    
    return toggle
end

-- Sliders
function MinecraftUI:CreateSlider(tab, text, min, max, default, callback)
    local slider = {}
    slider.value = default or min
    slider.min = min
    slider.max = max
    
    -- Calculate position
    local yPos = #tab.buttons * 30 + 10
    
    -- Slider frame
    local sliderFrame = createFrame(tab.content, UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, yPos), colors.window)
    sliderFrame.BackgroundTransparency = 1
    
    -- Slider text
    local sliderText = createTextLabel(sliderFrame, text .. ": " .. slider.value, UDim2.new(1, 0, 0, 15), UDim2.new(0, 0, 0, 0))
    
    -- Slider background
    local sliderBg = createFrame(sliderFrame, UDim2.new(1, 0, 0, 15), UDim2.new(0, 0, 0, 25), colors.slider)
    
    -- Slider fill
    local fillAmount = (slider.value - min) / (max - min)
    local sliderFill = createFrame(sliderBg, UDim2.new(fillAmount, 0, 1, 0), UDim2.new(0, 0, 0, 0), colors.sliderFill)
    
    -- Slider button
    local sliderButton = createFrame(sliderBg, UDim2.new(0, 6, 1, 0), UDim2.new(fillAmount, -3, 0, 0), colors.buttonText)
    
    -- Drag logic
    local dragging = false
    
    local function updateSlider(input)
        local sliderWidth = sliderBg.AbsoluteSize.X
        local sliderPos = sliderBg.AbsolutePosition.X
        local mouseX = input.Position.X
        
        -- Calculate new position
        local relativeX = math.clamp(mouseX - sliderPos, 0, sliderWidth)
        local percentage = relativeX / sliderWidth
        local newValue = math.floor(min + (max - min) * percentage)
        
        -- Update only if value changed
        if newValue ~= slider.value then
            slider.value = newValue
            sliderText.Text = text .. ": " .. slider.value
            
            -- Update visuals
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderButton.Position = UDim2.new(percentage, -3, 0, 0)
            
            if callback then
                callback(slider.value)
            end
        end
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    -- Store reference
    slider.frame = sliderFrame
    table.insert(tab.buttons, slider)
    
    return slider
end

-- Dropdowns
function MinecraftUI:CreateDropdown(tab, text, options, default, callback)
    local dropdown = {}
    dropdown.options = options
    dropdown.value = default or options[1]
    dropdown.open = false
    
    -- Calculate position
    local yPos = #tab.buttons * 30 + 10
    
    -- Dropdown frame
    local dropdownFrame = createFrame(tab.content, UDim2.new(1, -20, 0, 25), UDim2.new(0, 10, 0, yPos), colors.window)
    dropdownFrame.BackgroundTransparency = 1
    
    -- Dropdown text
    local dropdownText = createTextLabel(dropdownFrame, text, UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    
    -- Dropdown button
    local dropdownButton = createFrame(dropdownFrame, UDim2.new(0.5, 0, 1, 0), UDim2.new(0.5, 0, 0, 0), colors.dropdown)
    local buttonText = createTextLabel(dropdownButton, dropdown.value, UDim2.new(1, -20, 1, 0), UDim2.new(0, 5, 0, 0), colors.dropdownText)
    
    -- Dropdown arrow
    local arrow = createTextLabel(dropdownButton, "▼", UDim2.new(0, 15, 1, 0), UDim2.new(1, -15, 0, 0), colors.dropdownText)
    arrow.TextXAlignment = Enum.TextXAlignment.Right
    
    -- Dropdown options frame
    local optionsFrame = createFrame(dropdownFrame, UDim2.new(0.5, 0, 0, 0), UDim2.new(0.5, 0, 1, 0), colors.dropdown)
    optionsFrame.Visible = false
    optionsFrame.ClipsDescendants = true
    
    -- Create options
    local optionButtons = {}
    
    local function toggleDropdown()
        dropdown.open = not dropdown.open
        
        if dropdown.open then
            optionsFrame.Size = UDim2.new(0.5, 0, 0, #dropdown.options * 25)
            optionsFrame.Visible = true
            arrow.Text = "▲"
        else
            optionsFrame.Size = UDim2.new(0.5, 0, 0, 0)
            optionsFrame.Visible = false
            arrow.Text = "▼"
        end
    end
    
    -- Create option buttons
    for i, option in ipairs(dropdown.options) do
        local optionButton = createFrame(optionsFrame, UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, (i-1)*25), colors.dropdown)
        local optionText = createTextLabel(optionButton, option, UDim2.new(1, -5, 1, 0), UDim2.new(0, 5, 0, 0), colors.dropdownText)
        
        -- Hover effect
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundColor3 = colors.dropdownHover
        end)
        
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundColor3 = colors.dropdown
        end)
        
        -- Click handler
        optionButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dropdown.value = option
                buttonText.Text = option
                toggleDropdown()
                
                if callback then
                    callback(option)
                end
            end
        end)
        
        table.insert(optionButtons, optionButton)
    end
    
    -- Main button click
    dropdownButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleDropdown()
        end
    end)
    
    -- Close dropdown when clicking outside
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dropdown.open then
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local absolutePos = optionsFrame.AbsolutePosition
                local absoluteSize = optionsFrame.AbsoluteSize
                
                if not (mousePos.X >= absolutePos.X and mousePos.X <= absolutePos.X + absoluteSize.X and
                       mousePos.Y >= absolutePos.Y and mousePos.Y <= absolutePos.Y + absoluteSize.Y) then
                    toggleDropdown()
                end
            end
        end
    end)
    
    -- Store reference
    dropdown.frame = dropdownFrame
    table.insert(tab.buttons, dropdown)
    
    return dropdown
end

-- Textbox
function MinecraftUI:CreateTextbox(tab, text, placeholder, callback)
    local textbox = {}
    
    -- Calculate position
    local yPos = #tab.buttons * 30 + 10
    
    -- Textbox frame
    local textboxFrame = createFrame(tab.content, UDim2.new(1, -20, 0, 25), UDim2.new(0, 10, 0, yPos), colors.window)
    textboxFrame.BackgroundTransparency = 1
    
    -- Textbox label
    local textboxLabel = createTextLabel(textboxFrame, text, UDim2.new(0.3, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    
    -- Textbox input
    local textboxInput = createTextBox(textboxFrame, placeholder, UDim2.new(0.7, 0, 1, 0), UDim2.new(0.3, 0, 0, 0))
    
    -- Focus lost handler
    textboxInput.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(textboxInput.Text)
        end
    end)
    
    -- Store reference
    textbox.frame = textboxFrame
    table.insert(tab.buttons, textbox)
    
    return textbox
end

-- Label
function MinecraftUI:CreateLabel(tab, text)
    local label = {}
    
    -- Calculate position
    local yPos = #tab.buttons * 30 + 10
    
    -- Label frame
    local labelFrame = createFrame(tab.content, UDim2.new(1, -20, 0, 25), UDim2.new(0, 10, 0, yPos), colors.window)
    labelFrame.BackgroundTransparency = 1
    
    -- Label text
    local labelText = createTextLabel(labelFrame, text, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    
    -- Store reference
    label.frame = labelFrame
    table.insert(tab.buttons, label)
    
    return label
end

return MinecraftUI
