local ModernUILib = {}
ModernUILib.__index = ModernUILib

-- Theme configuration
ModernUILib.Theme = {
    Background = Color3.fromRGB(30, 30, 35),
    TabHeader = Color3.fromRGB(45, 45, 50),
    Button = Color3.fromRGB(50, 50, 55),
    ButtonHover = Color3.fromRGB(65, 65, 70),
    TextColor = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(100, 150, 255),
    Shadow = Color3.fromRGB(0, 0, 0, 0.5),
    CornerRadius = 8,
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamSemibold,
    TextSize = 14
}

-- Create a new UI instance
function ModernUILib.new(options)
    local self = setmetatable({}, ModernUILib)
    
    -- Merge custom options with defaults
    self.options = {
        Name = options.Name or "ModernUI",
        Size = options.Size or UDim2.new(0, 400, 0, 500),
        Position = options.Position or UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = options.AnchorPoint or Vector2.new(0.5, 0.5),
        Tabs = options.Tabs or {
            {
                Name = "Combat",
                Buttons = {"Kill Aura", "Auto Click", "Reach", "Hitboxes"}
            },
            {
                Name = "Rage",
                Buttons = {"Spinbot", "Anti-Aim", "Fake Lag", "BHop"}
            },
            {
                Name = "Visual",
                Buttons = {"ESP", "Chams", "Tracers", "Fullbright"}
            }
        }
    }
    
    self.currentTab = nil
    self.tabFrames = {}
    self.buttons = {}
    
    self:Initialize()
    return self
end

-- Initialize the UI
function ModernUILib:Initialize()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    
    -- Create main GUI
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = self.options.Name
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Create main container
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "MainFrame"
    self.mainFrame.BackgroundColor3 = self.Theme.Background
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Size = self.options.Size
    self.mainFrame.AnchorPoint = self.options.AnchorPoint
    self.mainFrame.Position = self.options.Position
    
    -- Add corner rounding
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, self.Theme.CornerRadius)
    UICorner.Parent = self.mainFrame
    
    -- Add shadow effect
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.BackgroundTransparency = 1
    DropShadow.Size = UDim2.new(1, 10, 1, 10)
    DropShadow.Position = UDim2.new(0, -5, 0, -5)
    DropShadow.Image = "rbxassetid://1316045217"
    DropShadow.ImageColor3 = self.Theme.Shadow
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    DropShadow.Parent = self.mainFrame
    
    -- Create tab buttons container
    self.tabButtons = Instance.new("Frame")
    self.tabButtons.Name = "TabButtons"
    self.tabButtons.BackgroundTransparency = 1
    self.tabButtons.Size = UDim2.new(1, 0, 0, 40)
    self.tabButtons.Position = UDim2.new(0, 0, 0, 0)
    self.tabButtons.Parent = self.mainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = self.tabButtons
    
    -- Create content frame
    self.contentFrame = Instance.new("Frame")
    self.contentFrame.Name = "ContentFrame"
    self.contentFrame.BackgroundTransparency = 1
    self.contentFrame.Size = UDim2.new(1, 0, 1, -40)
    self.contentFrame.Position = UDim2.new(0, 0, 0, 40)
    self.contentFrame.Parent = self.mainFrame
    
    -- Create all tabs
    for i, tabData in ipairs(self.options.Tabs) do
        self:CreateTab(tabData, i)
    end
    
    -- Make the UI draggable
    self:SetupDraggable()
    
    self.mainFrame.Parent = self.gui
end

-- Create a tab
function ModernUILib:CreateTab(tabData, index)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabData.Name.."Tab"
    TabButton.Text = tabData.Name
    TabButton.Size = UDim2.new(0.3, 0, 1, 0)
    TabButton.BackgroundColor3 = self.Theme.TabHeader
    TabButton.TextColor3 = self.Theme.TextColor
    TabButton.Font = self.Theme.FontBold
    TabButton.TextSize = self.Theme.TextSize
    TabButton.BorderSizePixel = 0
    
    -- Add corner rounding to top only
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, self.Theme.CornerRadius)
    UICorner.Parent = TabButton
    
    -- Add dropdown arrow
    local Arrow = Instance.new("ImageLabel")
    Arrow.Name = "Arrow"
    Arrow.Image = "rbxassetid://3926305904"
    Arrow.ImageRectOffset = Vector2.new(964, 324)
    Arrow.ImageRectSize = Vector2.new(36, 36)
    Arrow.Size = UDim2.new(0, 16, 0, 16)
    Arrow.Position = UDim2.new(1, -20, 0.5, -8)
    Arrow.BackgroundTransparency = 1
    Arrow.ImageColor3 = self.Theme.TextColor
    Arrow.Parent = TabButton
    
    -- Create tab content frame
    local TabFrame = Instance.new("Frame")
    TabFrame.Name = tabData.Name.."Frame"
    TabFrame.BackgroundTransparency = 1
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.Visible = false
    TabFrame.Parent = self.contentFrame
    
    -- Create buttons for this tab
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Size = UDim2.new(1, -20, 1, -20)
    ButtonContainer.Position = UDim2.new(0, 10, 0, 10)
    ButtonContainer.Visible = false -- Initially hidden
    ButtonContainer.Parent = TabFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ButtonContainer
    
    -- Store button references
    self.buttons[tabData.Name] = {}
    
    for i, btnName in ipairs(tabData.Buttons) do
        local Button = Instance.new("TextButton")
        Button.Name = btnName
        Button.Text = btnName
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.BackgroundColor3 = self.Theme.Button
        Button.TextColor3 = self.Theme.TextColor
        Button.Font = self.Theme.Font
        Button.TextSize = self.Theme.TextSize
        Button.BorderSizePixel = 0
        
        -- Add corner rounding
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, self.Theme.CornerRadius)
        UICorner.Parent = Button
        
        -- Store button reference
        self.buttons[tabData.Name][btnName] = Button
        
        -- Hover effect
        Button.MouseEnter:Connect(function()
            self:Tween(Button, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
        end)
        
        Button.MouseLeave:Connect(function()
            self:Tween(Button, {BackgroundColor3 = self.Theme.Button}, 0.2)
        end)
        
        -- Click effect
        Button.MouseButton1Down:Connect(function()
            self:Tween(Button, {
                BackgroundColor3 = self.Theme.Accent,
                TextColor3 = Color3.new(1, 1, 1)
            }, 0.1)
        end)
        
        Button.MouseButton1Up:Connect(function()
            self:Tween(Button, {
                BackgroundColor3 = self.Theme.ButtonHover,
                TextColor3 = self.Theme.TextColor
            }, 0.2)
        end)
        
        Button.Parent = ButtonContainer
    end
    
    -- Tab button click functionality
    TabButton.MouseButton1Click:Connect(function()
        if self.currentTab == TabButton then
            -- Toggle dropdown
            local isVisible = ButtonContainer.Visible
            ButtonContainer.Visible = not isVisible
            
            -- Rotate arrow
            self:Tween(Arrow, {Rotation = isVisible and 0 or 180}, 0.2)
            
            -- Fade in/out effect
            ButtonContainer.BackgroundTransparency = isVisible and 1 or 0.9
            if not isVisible then
                ButtonContainer.Visible = true
                self:Tween(ButtonContainer, {BackgroundTransparency = 0.9}, 0.2)
            end
        else
            -- Hide previous tab's buttons if any
            if self.currentTab then
                local prevArrow = self.currentTab:FindFirstChild("Arrow")
                local prevFrame = self.tabFrames[self.currentTab]
                if prevArrow and prevFrame then
                    self:Tween(prevArrow, {Rotation = 0}, 0.2)
                    prevFrame.ButtonContainer.Visible = false
                end
            end
            
            -- Show new tab
            self.currentTab = TabButton
            for _, frame in pairs(self.contentFrame:GetChildren()) do
                frame.Visible = false
            end
            TabFrame.Visible = true
            
            -- Show buttons and rotate arrow
            ButtonContainer.Visible = true
            self:Tween(Arrow, {Rotation = 180}, 0.2)
            
            -- Fade in effect
            ButtonContainer.BackgroundTransparency = 0.9
            self:Tween(ButtonContainer, {BackgroundTransparency = 0.9}, 0.2)
        end
    end)
    
    TabButton.Parent = self.tabButtons
    self.tabFrames[TabButton] = TabFrame
    
    -- Set first tab as active by default
    if index == 1 then
        TabButton.BackgroundColor3 = self.Theme.Accent
        TabFrame.Visible = true
        self.currentTab = TabButton
    end
end

-- Helper function for tweening
function ModernUILib:Tween(instance, properties, duration)
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(duration or 0.2)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Setup draggable functionality
function ModernUILib:SetupDraggable()
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        self.mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
    self.mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Add a button to a tab
function ModernUILib:AddButton(tabName, buttonName, callback)
    if not self.buttons[tabName] then
        warn("Tab '"..tabName.."' not found!")
        return
    end
    
    -- Find the tab frame
    local tabFrame
    for _, frame in pairs(self.tabFrames) do
        if frame.Name == tabName.."Frame" then
            tabFrame = frame
            break
        end
    end
    
    if not tabFrame then return end
    
    local ButtonContainer = tabFrame:FindFirstChild("ButtonContainer")
    if not ButtonContainer then return end
    
    -- Create the button
    local Button = Instance.new("TextButton")
    Button.Name = buttonName
    Button.Text = buttonName
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = self.Theme.Button
    Button.TextColor3 = self.Theme.TextColor
    Button.Font = self.Theme.Font
    Button.TextSize = self.Theme.TextSize
    Button.BorderSizePixel = 0
    
    -- Add corner rounding
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, self.Theme.CornerRadius)
    UICorner.Parent = Button
    
    -- Store button reference
    self.buttons[tabName][buttonName] = Button
    
    -- Hover effect
    Button.MouseEnter:Connect(function()
        self:Tween(Button, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        self:Tween(Button, {BackgroundColor3 = self.Theme.Button}, 0.2)
    end)
    
    -- Click effect
    Button.MouseButton1Down:Connect(function()
        self:Tween(Button, {
            BackgroundColor3 = self.Theme.Accent,
            TextColor3 = Color3.new(1, 1, 1)
        }, 0.1)
    end)
    
    Button.MouseButton1Up:Connect(function()
        self:Tween(Button, {
            BackgroundColor3 = self.Theme.ButtonHover,
            TextColor3 = self.Theme.TextColor
        }, 0.2)
        
        -- Call the callback if provided
        if callback then
            callback()
        end
    end)
    
    Button.Parent = ButtonContainer
end

-- Toggle UI visibility
function ModernUILib:Toggle()
    self.gui.Enabled = not self.gui.Enabled
end

-- Show UI
function ModernUILib:Show()
    self.gui.Enabled = true
end

-- Hide UI
function ModernUILib:Hide()
    self.gui.Enabled = false
end

-- Destroy UI
function ModernUILib:Destroy()
    self.gui:Destroy()
end

return ModernUILib
