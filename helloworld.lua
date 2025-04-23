-- RISE UI Library for Roblox
-- Dark, modern, sleek design

local RiseUI = {}
RiseUI.__index = RiseUI

-- Color palette
local colors = {
    background = Color3.fromRGB(20, 20, 25),
    primary = Color3.fromRGB(40, 40, 50),
    accent = Color3.fromRGB(0, 150, 255),
    text = Color3.fromRGB(220, 220, 220),
    border = Color3.fromRGB(60, 60, 70),
    slider = Color3.fromRGB(0, 120, 215),
    toggleOn = Color3.fromRGB(0, 180, 50),
    toggleOff = Color3.fromRGB(80, 80, 80)
}

-- Utility functions
local function create(class, props)
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        if prop == "Parent" then
            instance.Parent = value
        else
            instance[prop] = value
        end
    end
    return instance
end

-- Main window creation
function RiseUI.new(title)
    local self = setmetatable({}, RiseUI)
    
    -- Main screen gui
    self.screenGui = create("ScreenGui", {
        Name = "RiseUI",
        ResetOnSpawn = false
    })
    
    -- Main window frame
    self.mainFrame = create("Frame", {
        Name = "MainWindow",
        Size = UDim2.new(0, 400, 0, 500),
        Position = UDim2.new(0.5, -200, 0.5, -250),
        BackgroundColor3 = colors.background,
        BorderColor3 = colors.border,
        BorderSizePixel = 1,
        Parent = self.screenGui
    })
    
    -- Window title bar
    self.titleBar = create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = colors.primary,
        BorderSizePixel = 0,
        Parent = self.mainFrame
    })
    
    -- Window title text
    self.titleLabel = create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "RISE UI",
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        Parent = self.titleBar
    })
    
    -- Close button
    self.closeButton = create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        BorderSizePixel = 0,
        Text = "X",
        TextColor3 = colors.text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = self.titleBar
    })
    
    -- Tab container
    self.tabContainer = create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = colors.primary,
        BorderSizePixel = 0,
        Parent = self.mainFrame
    })
    
    -- Content container
    self.contentContainer = create("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, -70),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = colors.accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.mainFrame
    })
    
    -- UIListLayout for content
    create("UIListLayout", {
        Name = "ContentLayout",
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = self.contentContainer
    })
    
    -- Padding for content
    create("UIPadding", {
        Name = "ContentPadding",
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
        Parent = self.contentContainer
    })
    
    -- Tab buttons will be stored here
    self.tabs = {}
    self.currentTab = nil
    
    -- Make window draggable
    self:dragify(self.mainFrame, self.titleBar)
    
    -- Close button functionality
    self.closeButton.MouseButton1Click:Connect(function()
        self.screenGui:Destroy()
    end)
    
    return self
end

-- Make frame draggable
function RiseUI:dragify(frame, dragPart)
    local dragStart, startPos
    
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragStart = nil
                end
            end)
        end
    end)
    
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Add tab to window
function RiseUI:addTab(name)
    local tabButton = create("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(0, 80, 1, 0),
        BackgroundColor3 = colors.primary,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = colors.text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = self.tabContainer
    })
    
    local tabContent = create("Frame", {
        Name = name .. "Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.contentContainer
    })
    
    -- UIListLayout for tab content
    create("UIListLayout", {
        Name = name .. "ContentLayout",
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = tabContent
    })
    
    -- Padding for tab content
    create("UIPadding", {
        Name = name .. "ContentPadding",
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = tabContent
    })
    
    -- Tab button functionality
    tabButton.MouseButton1Click:Connect(function()
        self:switchTab(name)
    end)
    
    self.tabs[name] = {
        button = tabButton,
        content = tabContent
    }
    
    -- If this is the first tab, make it active
    if not self.currentTab then
        self:switchTab(name)
    end
    
    return tabContent
end

-- Switch between tabs
function RiseUI:switchTab(name)
    if self.currentTab == name then return end
    
    -- Hide current tab
    if self.currentTab then
        self.tabs[self.currentTab].content.Visible = false
        self.tabs[self.currentTab].button.BackgroundColor3 = colors.primary
    end
    
    -- Show new tab
    self.tabs[name].content.Visible = true
    self.tabs[name].button.BackgroundColor3 = colors.accent
    self.currentTab = name
end

-- Add button to tab
function RiseUI:addButton(tabName, text, callback)
    local tab = self.tabs[tabName].content
    if not tab then return end
    
    local button = create("TextButton", {
        Name = text .. "Button",
        Size = UDim2.new(1, -10, 0, 30),
        BackgroundColor3 = colors.primary,
        BorderColor3 = colors.border,
        BorderSizePixel = 1,
        Text = text,
        TextColor3 = colors.text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        LayoutOrder = #tab:GetChildren(),
        Parent = tab
    })
    
    -- Button hover effects
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = colors.primary
    end)
    
    -- Button click functionality
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Add toggle to tab
function RiseUI:addToggle(tabName, text, default, callback)
    local tab = self.tabs[tabName].content
    if not tab then return end
    
    local toggleFrame = create("Frame", {
        Name = text .. "Toggle",
        Size = UDim2.new(1, -10, 0, 25),
        BackgroundTransparency = 1,
        LayoutOrder = #tab:GetChildren(),
        Parent = tab
    })
    
    local toggleButton = create("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = default and colors.toggleOn or colors.toggleOff,
        BorderSizePixel = 0,
        Text = "",
        Parent = toggleFrame
    })
    
    local toggleLabel = create("TextLabel", {
        Name = "ToggleLabel",
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = toggleFrame
    })
    
    -- Toggle functionality
    local state = default or false
    
    local function updateToggle()
        toggleButton.BackgroundColor3 = state and colors.toggleOn or colors.toggleOff
        if callback then
            callback(state)
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
    end)
    
    return {
        set = function(newState)
            state = newState
            updateToggle()
        end,
        get = function()
            return state
        end
    }
end

-- Add slider to tab
function RiseUI:addSlider(tabName, text, min, max, default, callback)
    local tab = self.tabs[tabName].content
    if not tab then return end
    
    local sliderFrame = create("Frame", {
        Name = text .. "Slider",
        Size = UDim2.new(1, -10, 0, 50),
        BackgroundTransparency = 1,
        LayoutOrder = #tab:GetChildren(),
        Parent = tab
    })
    
    local sliderLabel = create("TextLabel", {
        Name = "SliderLabel",
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = text .. ": " .. default,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = sliderFrame
    })
    
    local sliderTrack = create("Frame", {
        Name = "SliderTrack",
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = colors.primary,
        BorderSizePixel = 0,
        Parent = sliderFrame
    })
    
    local sliderFill = create("Frame", {
        Name = "SliderFill",
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = colors.slider,
        BorderSizePixel = 0,
        Parent = sliderTrack
    })
    
    local sliderButton = create("TextButton", {
        Name = "SliderButton",
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(sliderFill.Size.X.Scale, -7, 0.5, -7),
        BackgroundColor3 = colors.accent,
        BorderSizePixel = 0,
        Text = "",
        Parent = sliderTrack
    })
    
    -- Slider functionality
    local dragging = false
    local value = default
    
    local function updateSlider(input)
        local relativeX = (input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        value = math.floor(min + (max - min) * relativeX)
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderButton.Position = UDim2.new(relativeX, -7, 0.5, -7)
        sliderLabel.Text = text .. ": " .. value
        
        if callback then
            callback(value)
        end
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    sliderButton.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
        end
    end)
    
    return {
        set = function(newValue)
            value = math.clamp(newValue, min, max)
            local relativeX = (value - min) / (max - min)
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderButton.Position = UDim2.new(relativeX, -7, 0.5, -7)
            sliderLabel.Text = text .. ": " .. value
        end,
        get = function()
            return value
        end
    }
end

-- Add label to tab
function RiseUI:addLabel(tabName, text)
    local tab = self.tabs[tabName].content
    if not tab then return end
    
    local label = create("TextLabel", {
        Name = text .. "Label",
        Size = UDim2.new(1, -10, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = colors.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        LayoutOrder = #tab:GetChildren(),
        Parent = tab
    })
    
    return label
end

-- Add dropdown to tab
function RiseUI:addDropdown(tabName, text, options, default, callback)
    local tab = self.tabs[tabName].content
    if not tab then return end
    
    local dropdownFrame = create("Frame", {
        Name = text .. "Dropdown",
        Size = UDim2.new(1, -10, 0, 25),
        BackgroundTransparency = 1,
        LayoutOrder = #tab:GetChildren(),
        Parent = tab
    })
    
    local dropdownButton = create("TextButton", {
        Name = "DropdownButton",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundColor3 = colors.primary,
        BorderColor3 = colors.border,
        BorderSizePixel = 1,
        Text = text .. ": " .. (options[default] or options[1]),
        TextColor3 = colors.text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = dropdownFrame
    })
    
    local dropdownList = create("ScrollingFrame", {
        Name = "DropdownList",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = colors.primary,
        BorderColor3 = colors.border,
        BorderSizePixel = 1,
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = colors.accent,
        Visible = false,
        Parent = dropdownFrame
    })
    
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = dropdownList
    })
    
    -- Populate dropdown options
    for i, option in ipairs(options) do
        local optionButton = create("TextButton", {
            Name = option .. "Option",
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = colors.primary,
            BorderSizePixel = 0,
            Text = option,
            TextColor3 = colors.text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            LayoutOrder = i,
            Parent = dropdownList
        })
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = text .. ": " .. option
            dropdownList.Visible = false
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
            
            if callback then
                callback(option, i)
            end
        end)
        
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end)
        
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundColor3 = colors.primary
        end)
    end
    
    -- Toggle dropdown visibility
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        dropdownList.Size = dropdownList.Visible and UDim2.new(1, 0, 0, math.min(#options * 25, 125)) or UDim2.new(1, 0, 0, 0)
    end)
    
    return {
        set = function(option)
            if table.find(options, option) then
                dropdownButton.Text = text .. ": " .. option
                if callback then
                    callback(option, table.find(options, option))
                end
            end
        end,
        get = function()
            return string.sub(dropdownButton.Text, string.len(text) + 3)
        end
    }
end

return RiseUI
