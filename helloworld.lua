local UltraUI = {}

-- Enhanced Color Palette
local colors = {
    background = Color3.fromRGB(20, 20, 25),
    secondary = Color3.fromRGB(30, 30, 38),
    accent = Color3.fromRGB(0, 180, 255),
    success = Color3.fromRGB(0, 200, 100),
    warning = Color3.fromRGB(255, 180, 0),
    danger = Color3.fromRGB(220, 60, 60),
    text = Color3.fromRGB(245, 245, 245),
    textSecondary = Color3.fromRGB(180, 180, 180),
    hover = Color3.fromRGB(45, 45, 55),
    stroke = Color3.fromRGB(50, 50, 60),
    checkmark = Color3.fromRGB(255, 255, 255)
}

-- Animation Settings
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local fastTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Utility Functions
local function createRoundCorners(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(radius, 0)
    corner.Parent = instance
    return corner
end

local function createStroke(instance, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color or colors.stroke
    stroke.Transparency = transparency or 0
    stroke.Parent = instance
    return stroke
end

local function createPadding(instance, left, right, top, bottom)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, left or 8)
    pad.PaddingRight = UDim.new(0, right or 8)
    pad.PaddingTop = UDim.new(0, top or 8)
    pad.PaddingBottom = UDim.new(0, bottom or 8)
    pad.Parent = instance
    return pad
end

local function createGradient(instance, rotation, colors)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = rotation or 0
    gradient.Color = ColorSequence.new(colors or {
        ColorSequenceKeypoint.new(0, colors.accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 255))
    })
    gradient.Parent = instance
    return gradient
end

-- Main Window Creation
function UltraUI:CreateWindow(title, options)
    options = options or {}
    local config = {
        size = options.size or UDim2.new(0, 450, 0, 500),
        position = options.position or UDim2.new(0.5, -225, 0.5, -250),
        accentColor = options.accentColor or colors.accent,
        minSize = options.minSize or UDim2.new(0, 300, 0, 300),
        resizable = options.resizable ~= false
    }
    
    -- Main Container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UltraUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = config.size
    mainFrame.Position = config.position
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Parent = screenGui
    
    createRoundCorners(mainFrame, 0.08)
    createStroke(mainFrame, 2)
    
    -- Enhanced Shadow Effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 14, 1, 14)
    shadow.Position = UDim2.new(0, -7, 0, -7)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.9
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    -- Title Bar with Gradient
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = colors.secondary
    titleBar.Parent = mainFrame
    
    local titleBarGradient = Instance.new("Frame")
    titleBarGradient.Size = UDim2.new(1, 0, 0, 2)
    titleBarGradient.Position = UDim2.new(0, 0, 1, -2)
    titleBarGradient.BackgroundColor3 = colors.accent
    titleBarGradient.Parent = titleBar
    createGradient(titleBarGradient, 0)
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 12, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "Ultra UI"
    titleText.TextColor3 = colors.text
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamSemibold
    titleText.TextSize = 15
    titleText.Parent = titleBar
    
    -- Close Button with Icon
    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Image = "rbxassetid://3926307971"
    closeButton.ImageColor3 = colors.textSecondary
    closeButton.ImageRectOffset = Vector2.new(284, 4)
    closeButton.ImageRectSize = Vector2.new(24, 24)
    closeButton.Parent = titleBar
    
    closeButton.MouseEnter:Connect(function()
        tweenService:Create(closeButton, fastTweenInfo, {ImageColor3 = colors.text}):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        tweenService:Create(closeButton, fastTweenInfo, {ImageColor3 = colors.textSecondary}):Play()
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab System
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
    tabButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
    tabButtonsFrame.BackgroundColor3 = colors.secondary
    tabButtonsFrame.Parent = mainFrame
    
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = "TabContent"
    tabContentFrame.Size = UDim2.new(1, -20, 1, -100)
    tabContentFrame.Position = UDim2.new(0, 10, 0, 90)
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
    
    -- Make resizable
    if config.resizable then
        local resizeHandle = Instance.new("Frame")
        resizeHandle.Name = "ResizeHandle"
        resizeHandle.Size = UDim2.new(0, 16, 0, 16)
        resizeHandle.Position = UDim2.new(1, -16, 1, -16)
        resizeHandle.BackgroundTransparency = 1
        resizeHandle.Parent = mainFrame
        
        local resizeIcon = Instance.new("ImageLabel")
        resizeIcon.Name = "ResizeIcon"
        resizeIcon.Size = UDim2.new(1, 0, 1, 0)
        resizeIcon.BackgroundTransparency = 1
        resizeIcon.Image = "rbxassetid://3926307971"
        resizeIcon.ImageColor3 = colors.textSecondary
        resizeIcon.ImageRectOffset = Vector2.new(884, 284)
        resizeIcon.ImageRectSize = Vector2.new(36, 36)
        resizeIcon.Rotation = 180
        resizeIcon.Parent = resizeHandle
        
        local resizing = false
        local resizeStart, resizeStartSize
        
        resizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                resizeStart = input.Position
                resizeStartSize = mainFrame.Size
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        resizing = false
                    end
                end)
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - resizeStart
                local newSize = UDim2.new(
                    resizeStartSize.X.Scale, 
                    math.max(config.minSize.X.Offset, resizeStartSize.X.Offset + delta.X),
                    resizeStartSize.Y.Scale,
                    math.max(config.minSize.Y.Offset, resizeStartSize.Y.Offset + delta.Y)
                )
                mainFrame.Size = newSize
            end
        end)
    end
    
    -- Enhanced Tab Functions
    function tabs:CreateTab(name, icon)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "TabButton"
        tabButton.Size = UDim2.new(0, 80, 1, 0)
        tabButton.Position = UDim2.new(0, (#tabs * 80), 0, 0)
        tabButton.BackgroundColor3 = colors.secondary
        tabButton.BackgroundTransparency = 1
        tabButton.Text = icon and "" or name
        tabButton.TextColor3 = colors.textSecondary
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 12
        tabButton.Parent = tabButtonsFrame
        
        if icon then
            local tabIcon = Instance.new("ImageLabel")
            tabIcon.Name = "TabIcon"
            tabIcon.Size = UDim2.new(0, 20, 0, 20)
            tabIcon.Position = UDim2.new(0.5, -10, 0.5, -10)
            tabIcon.BackgroundTransparency = 1
            tabIcon.Image = "rbxassetid://3926307971"
            tabIcon.ImageRectOffset = icon.offset or Vector2.new(0, 0)
            tabIcon.ImageRectSize = icon.size or Vector2.new(36, 36)
            tabIcon.ImageColor3 = colors.textSecondary
            tabIcon.Parent = tabButton
            
            local tabTooltip = Instance.new("TextLabel")
            tabTooltip.Name = "Tooltip"
            tabTooltip.Size = UDim2.new(0, 0, 0, 24)
            tabTooltip.Position = UDim2.new(0.5, 0, 1, 5)
            tabTooltip.BackgroundColor3 = colors.secondary
            tabTooltip.Text = name
            tabTooltip.TextColor3 = colors.text
            tabTooltip.Font = Enum.Font.Gotham
            tabTooltip.TextSize = 12
            tabTooltip.Visible = false
            tabTooltip.ZIndex = 100
            tabTooltip.Parent = tabButton
            
            createRoundCorners(tabTooltip, 0.05)
            createStroke(tabTooltip, 1)
            createPadding(tabTooltip, 8, 8, 4, 4)
            
            tabButton.MouseEnter:Connect(function()
                tweenService:Create(tabIcon, tweenInfo, {ImageColor3 = colors.text}):Play()
                tabTooltip.Visible = true
                tweenService:Create(tabTooltip, tweenInfo, {Size = UDim2.new(0, name:len() * 7 + 16, 0, 24)}):Play()
            end)
            
            tabButton.MouseLeave:Connect(function()
                tweenService:Create(tabIcon, tweenInfo, {ImageColor3 = colors.textSecondary}):Play()
                tweenService:Create(tabTooltip, tweenInfo, {Size = UDim2.new(0, 0, 0, 24)}):Play()
                task.delay(0.2, function()
                    tabTooltip.Visible = false
                end)
            end)
        else
            tabButton.MouseEnter:Connect(function()
                tweenService:Create(tabButton, tweenInfo, {TextColor3 = colors.text}):Play()
            end)
            
            tabButton.MouseLeave:Connect(function()
                if currentTab ~= tabContent then
                    tweenService:Create(tabButton, tweenInfo, {TextColor3 = colors.textSecondary}):Play()
                end
            end)
        end
        
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
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.Visible = false
        tabContent.Parent = tabContentFrame
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Padding = UDim.new(0, 10)
        tabContentLayout.Parent = tabContent
        
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
                for _, btn in ipairs(tabButtonsFrame:GetChildren()) do
                    if btn:IsA("TextButton") then
                        tweenService:Create(btn, tweenInfo, {TextColor3 = colors.textSecondary}):Play()
                        if btn:FindFirstChild("TabIcon") then
                            tweenService:Create(btn.TabIcon, tweenInfo, {ImageColor3 = colors.textSecondary}):Play()
                        end
                        tweenService:Create(btn.Underline, tweenInfo, {BackgroundTransparency = 1}):Play()
                    end
                end
            end
            
            if tabButton:FindFirstChild("TabIcon") then
                tweenService:Create(tabButton.TabIcon, tweenInfo, {ImageColor3 = colors.text}):Play()
            else
                tweenService:Create(tabButton, tweenInfo, {TextColor3 = colors.text}):Play()
            end
            tweenService:Create(tabButton.Underline, tweenInfo, {BackgroundTransparency = 0}):Play()
            
            tabContent.Visible = true
            currentTab = tabContent
        end)
        
        -- Select first tab by default
        if #tabs == 0 then
            tabContent.Visible = true
            currentTab = tabContent
            if tabButton:FindFirstChild("TabIcon") then
                tabButton.TabIcon.ImageColor3 = colors.text
            else
                tabButton.TextColor3 = colors.text
            end
            underline.BackgroundTransparency = 0
        end
        
        table.insert(tabs, tabContent)
        
        local tabFunctions = {}
        
        -- Enhanced Section with optional collapsible feature
        function tabFunctions:CreateSection(name, collapsible)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name .. "Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 32)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Parent = tabContent
            
            local sectionText = Instance.new("TextLabel")
            sectionText.Name = "SectionText"
            sectionText.Size = UDim2.new(1, collapsible and -32 or 0, 1, 0)
            sectionText.Position = UDim2.new(0, 0, 0, 0)
            sectionText.BackgroundTransparency = 1
            sectionText.Text = string.upper(name)
            sectionText.TextColor3 = colors.textSecondary
            sectionText.TextXAlignment = Enum.TextXAlignment.Left
            sectionText.Font = Enum.Font.GothamSemibold
            sectionText.TextSize = 11
            sectionText.Parent = sectionFrame
            
            if collapsible then
                local collapseButton = Instance.new("ImageButton")
                collapseButton.Name = "CollapseButton"
                collapseButton.Size = UDim2.new(0, 24, 0, 24)
                collapseButton.Position = UDim2.new(1, -24, 0.5, -12)
                collapseButton.BackgroundTransparency = 1
                collapseButton.Image = "rbxassetid://3926307971"
                collapseButton.ImageColor3 = colors.textSecondary
                collapseButton.ImageRectOffset = Vector2.new(36, 324)
                collapseButton.ImageRectSize = Vector2.new(36, 36)
                collapseButton.Parent = sectionFrame
                
                local contentFrame = Instance.new("Frame")
                contentFrame.Name = "ContentFrame"
                contentFrame.Size = UDim2.new(1, 0, 0, 0)
                contentFrame.Position = UDim2.new(0, 0, 0, 32)
                contentFrame.BackgroundTransparency = 1
                contentFrame.ClipsDescendants = true
                contentFrame.Parent = sectionFrame
                
                local contentLayout = Instance.new("UIListLayout")
                contentLayout.Padding = UDim.new(0, 8)
                contentLayout.Parent = contentFrame
                
                local isExpanded = true
                
                collapseButton.MouseButton1Click:Connect(function()
                    isExpanded = not isExpanded
                    if isExpanded then
                        tweenService:Create(contentFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)}):Play()
                        tweenService:Create(collapseButton, tweenInfo, {Rotation = 0}):Play()
                    else
                        tweenService:Create(contentFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                        tweenService:Create(collapseButton, tweenInfo, {Rotation = 180}):Play()
                    end
                end)
                
                -- Update section functions to return content frame instead
                local sectionFunctions = {}
                
                function sectionFunctions:AddElement(element)
                    element.Parent = contentFrame
                    if isExpanded then
                        contentFrame.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
                    end
                    return element
                end
                
                return sectionFunctions
            end
            
            return sectionFrame
        end
        
        -- Enhanced Button with multiple styles
        function tabFunctions:CreateButton(name, callback, options)
            options = options or {}
            local buttonStyle = options.style or "default" -- "default", "accent", "danger", "success", "warning"
            
            local buttonColors = {
                default = {main = colors.secondary, hover = colors.hover, text = colors.text},
                accent = {main = colors.accent, hover = Color3.fromRGB(0, 160, 230), text = colors.text},
                danger = {main = colors.danger, hover = Color3.fromRGB(240, 80, 80), text = colors.text},
                success = {main = colors.success, hover = Color3.fromRGB(0, 220, 120), text = colors.text},
                warning = {main = colors.warning, hover = Color3.fromRGB(255, 200, 50), text = Color3.fromRGB(40, 40, 40)}
            }
            
            local button = Instance.new("TextButton")
            button.Name = name .. "Button"
            button.Size = UDim2.new(1, 0, 0, 36)
            button.BackgroundColor3 = buttonColors[buttonStyle].main
            button.Text = name
            button.TextColor3 = buttonColors[buttonStyle].text
            button.Font = Enum.Font.GothamSemibold
            button.TextSize = 12
            button.Parent = tabContent
            
            if options.icon then
                button.TextXAlignment = Enum.TextXAlignment.Left
                createPadding(button, 36, 8, 0, 0)
                
                local buttonIcon = Instance.new("ImageLabel")
                buttonIcon.Name = "ButtonIcon"
                buttonIcon.Size = UDim2.new(0, 20, 0, 20)
                buttonIcon.Position = UDim2.new(0, 8, 0.5, -10)
                buttonIcon.BackgroundTransparency = 1
                buttonIcon.Image = "rbxassetid://3926307971"
                buttonIcon.ImageColor3 = buttonColors[buttonStyle].text
                buttonIcon.ImageRectOffset = options.icon.offset or Vector2.new(0, 0)
                buttonIcon.ImageRectSize = options.icon.size or Vector2.new(36, 36)
                buttonIcon.Parent = button
            else
                createPadding(button, 8, 8, 0, 0)
            end
            
            createRoundCorners(button, 0.05)
            createStroke(button, 1)
            
            button.MouseEnter:Connect(function()
                tweenService:Create(button, tweenInfo, {BackgroundColor3 = buttonColors[buttonStyle].hover}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                tweenService:Create(button, tweenInfo, {BackgroundColor3 = buttonColors[buttonStyle].main}):Play()
            end)
            
            button.MouseButton1Click:Connect(function()
                -- Pulse animation on click
                tweenService:Create(button, fastTweenInfo, {BackgroundTransparency = 0.5}):Play()
                tweenService:Create(button, fastTweenInfo, {BackgroundTransparency = 0}):Play()
                
                if callback then
                    callback()
                end
            end)
            
            if options.tooltip then
                local tooltip = Instance.new("TextLabel")
                tooltip.Name = "Tooltip"
                tooltip.Size = UDim2.new(0, 0, 0, 24)
                tooltip.Position = UDim2.new(0.5, 0, -0.5, -5)
                tooltip.BackgroundColor3 = colors.secondary
                tooltip.Text = options.tooltip
                tooltip.TextColor3 = colors.text
                tooltip.Font = Enum.Font.Gotham
                tooltip.TextSize = 12
                tooltip.Visible = false
                tooltip.ZIndex = 100
                tooltip.Parent = button
                
                createRoundCorners(tooltip, 0.05)
                createStroke(tooltip, 1)
                createPadding(tooltip, 8, 8, 4, 4)
                
                button.MouseEnter:Connect(function()
                    tooltip.Visible = true
                    tweenService:Create(tooltip, tweenInfo, {Size = UDim2.new(0, options.tooltip:len() * 7 + 16, 0, 24)}):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    tweenService:Create(tooltip, tweenInfo, {Size = UDim2.new(0, 0, 0, 24)}):Play()
                    task.delay(0.2, function()
                        tooltip.Visible = false
                    end)
                end)
            end
            
            return button
        end
        
        -- Enhanced Toggle with multiple styles and animated checkmark
        function tabFunctions:CreateToggle(name, default, callback, options)
            options = options or {}
            local toggleStyle = options.style or "default" -- "default", "switch", "checkbox"
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = name .. "Toggle"
            toggleFrame.Size = UDim2.new(1, 0, 0, 32)
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
            
            local toggleButton
            local checkmark
            
            if toggleStyle == "switch" then
                -- Switch style toggle
                toggleButton = Instance.new("TextButton")
                toggleButton.Name = "ToggleButton"
                toggleButton.Size = UDim2.new(0, 48, 0, 24)
                toggleButton.Position = UDim2.new(1, -48, 0.5, -12)
                toggleButton.BackgroundColor3 = default and colors.success or colors.toggleOff
                toggleButton.Text = ""
                toggleButton.Parent = toggleFrame
                
                createRoundCorners(toggleButton, 0.5)
                createStroke(toggleButton, 1)
                
                local toggleKnob = Instance.new("Frame")
                toggleKnob.Name = "ToggleKnob"
                toggleKnob.Size = UDim2.new(0, 20, 0, 20)
                toggleKnob.Position = UDim2.new(default and 1 or 0, default and -20 or 2, 0.5, -10)
                toggleKnob.BackgroundColor3 = colors.text
                toggleKnob.Parent = toggleButton
                
                createRoundCorners(toggleKnob, 0.5)
                createStroke(toggleKnob, 1, colors.stroke)
                
                checkmark = toggleKnob
            elseif toggleStyle == "checkbox" then
                -- Checkbox style toggle
                toggleButton = Instance.new("TextButton")
                toggleButton.Name = "ToggleButton"
                toggleButton.Size = UDim2.new(0, 24, 0, 24)
                toggleButton.Position = UDim2.new(1, -24, 0.5, -12)
                toggleButton.BackgroundColor3 = default and colors.success or colors.secondary
                toggleButton.Text = ""
                toggleButton.Parent = toggleFrame
                
                createRoundCorners(toggleButton, 0.15)
                createStroke(toggleButton, 1)
                
                checkmark = Instance.new("ImageLabel")
                checkmark.Name = "Checkmark"
                checkmark.Size = UDim2.new(0, 16, 0, 16)
                checkmark.Position = UDim2.new(0.5, -8, 0.5, -8)
                checkmark.BackgroundTransparency = 1
                checkmark.Image = "rbxassetid://3926307971"
                checkmark.ImageColor3 = colors.checkmark
                checkmark.ImageRectOffset = Vector2.new(124, 204)
                checkmark.ImageRectSize = Vector2.new(16, 16)
                checkmark.Parent = toggleButton
                checkmark.Visible = default
            else
                -- Default rounded toggle
                toggleButton = Instance.new("TextButton")
                toggleButton.Name = "ToggleButton"
                toggleButton.Size = UDim2.new(0, 44, 0, 24)
                toggleButton.Position = UDim2.new(1, -44, 0.5, -12)
                toggleButton.BackgroundColor3 = default and colors.success or colors.toggleOff
                toggleButton.Text = ""
                toggleButton.Parent = toggleFrame
                
                createRoundCorners(toggleButton, 0.5)
                createStroke(toggleButton, 1)
                
                checkmark = Instance.new("ImageLabel")
                checkmark.Name = "Checkmark"
                checkmark.Size = UDim2.new(0, 16, 0, 16)
                checkmark.Position = UDim2.new(0.5, -8, 0.5, -8)
                checkmark.BackgroundTransparency = 1
                checkmark.Image = "rbxassetid://3926307971"
                checkmark.ImageColor3 = colors.checkmark
                checkmark.ImageRectOffset = Vector2.new(124, 204)
                checkmark.ImageRectSize = Vector2.new(16, 16)
                checkmark.Parent = toggleButton
                checkmark.Visible = default
            end
            
            local state = default or false
            
            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                
                if toggleStyle == "switch" then
                    if state then
                        tweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = colors.success}):Play()
                        tweenService:Create(checkmark, tweenInfo, {Position = UDim2.new(1, -20, 0.5, -10)}):Play()
                    else
                        tweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = colors.toggleOff}):Play()
                        tweenService:Create(checkmark, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
                    end
                else
                    if state then
                        tweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = colors.success}):Play()
                        checkmark.Visible = true
                        checkmark.ImageTransparency = 1
                        tweenService:Create(checkmark, tweenInfo, {ImageTransparency = 0}):Play()
                    else
                        tweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = toggleStyle == "checkbox" and colors.secondary or colors.toggleOff}):Play()
                        tweenService:Create(checkmark, tweenInfo, {ImageTransparency = 1}):Play()
                    end
                end
                
                if callback then
                    callback(state)
                end
            end)
            
            local toggleFunctions = {}
            
            function toggleFunctions:SetValue(newState)
                state = newState
                
                if toggleStyle == "switch" then
                    if state then
                        toggleButton.BackgroundColor3 = colors.success
                        checkmark.Position = UDim2.new(1, -20, 0.5, -10)
                    else
                        toggleButton.BackgroundColor3 = colors.toggleOff
                        checkmark.Position = UDim2.new(0, 2, 0.5, -10)
                    end
                else
                    if state then
                        toggleButton.BackgroundColor3 = colors.success
                        checkmark.Visible = true
                        checkmark.ImageTransparency = 0
                    else
                        toggleButton.BackgroundColor3 = toggleStyle == "checkbox" and colors.secondary or colors.toggleOff
                        checkmark.ImageTransparency = 1
                    end
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
        
        -- Enhanced Slider with value display and step option
        function tabFunctions:CreateSlider(name, min, max, default, callback, options)
            options = options or {}
            local step = options.step or 1
            local showInput = options.showInput ~= false
            local suffix = options.suffix or ""
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = name .. "Slider"
            sliderFrame.Size = UDim2.new(1, 0, 0, 56)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent
            
            local sliderHeader = Instance.new("Frame")
            sliderHeader.Name = "SliderHeader"
            sliderHeader.Size = UDim2.new(1, 0, 0, 20)
            sliderHeader.Position = UDim2.new(0, 0, 0, 0)
            sliderHeader.BackgroundTransparency = 1
            sliderHeader.Parent = sliderFrame
            
            local sliderText = Instance.new("TextLabel")
            sliderText.Name = "SliderText"
            sliderText.Size = showInput and UDim2.new(0.7, 0, 1, 0) or UDim2.new(1, 0, 1, 0)
            sliderText.Position = UDim2.new(0, 0, 0, 0)
            sliderText.BackgroundTransparency = 1
            sliderText.Text = name
            sliderText.TextColor3 = colors.text
            sliderText.TextXAlignment = Enum.TextXAlignment.Left
            sliderText.Font = Enum.Font.Gotham
            sliderText.TextSize = 12
            sliderText.Parent = sliderHeader
            
            local valueDisplay
            if showInput then
                valueDisplay = Instance.new("TextBox")
                valueDisplay.Name = "ValueDisplay"
                valueDisplay.Size = UDim2.new(0.3, 0, 1, 0)
                valueDisplay.Position = UDim2.new(0.7, 0, 0, 0)
                valueDisplay.BackgroundColor3 = colors.secondary
                valueDisplay.Text = tostring(default) .. suffix
                valueDisplay.TextColor3 = colors.text
                valueDisplay.Font = Enum.Font.Gotham
                valueDisplay.TextSize = 12
                valueDisplay.Parent = sliderHeader
                
                createRoundCorners(valueDisplay, 0.1)
                createStroke(valueDisplay, 1)
                createPadding(valueDisplay, 4, 4, 0, 0)
                
                valueDisplay.FocusLost:Connect(function()
                    local newValue = tonumber(valueDisplay.Text:gsub(suffix, ""))
                    if newValue then
                        newValue = math.clamp(newValue, min, max)
                        if step > 1 then
                            newValue = math.floor(newValue / step + 0.5) * step
                        end
                        slider:SetValue(newValue)
                    else
                        valueDisplay.Text = tostring(slider:GetValue()) .. suffix
                    end
                end)
            end
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Name = "SliderBar"
            sliderBar.Size = UDim2.new(1, 0, 0, 6)
            sliderBar.Position = UDim2.new(0, 0, 0, 30)
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
                
                local newValue = min + (max - min) * xScale
                if step > 1 then
                    newValue = math.floor(newValue / step + 0.5) * step
                    xScale = (newValue - min) / (max - min)
                end
                
                tweenService:Create(sliderFill, tweenInfo, {Size = UDim2.new(xScale, 0, 1, 0)}):Play()
                tweenService:Create(sliderHandle, tweenInfo, {Position = UDim2.new(xScale, -6, 0.5, -6)}):Play()
                
                value = newValue
                if valueDisplay then
                    valueDisplay.Text = tostring(value) .. suffix
                else
                    sliderText.Text = name .. ": " .. tostring(value) .. suffix
                end
                
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
                newValue = math.clamp(newValue, min, max)
                if step > 1 then
                    newValue = math.floor(newValue / step + 0.5) * step
                end
                
                local xScale = (newValue - min) / (max - min)
                
                tweenService:Create(sliderFill, tweenInfo, {Size = UDim2.new(xScale, 0, 1, 0)}):Play()
                tweenService:Create(sliderHandle, tweenInfo, {Position = UDim2.new(xScale, -6, 0.5, -6)}):Play()
                
                value = newValue
                if valueDisplay then
                    valueDisplay.Text = tostring(value) .. suffix
                else
                    sliderText.Text = name .. ": " .. tostring(value) .. suffix
                end
                
                if callback then
                    callback(value)
                end
            end
            
            function sliderFunctions:GetValue()
                return value
            end
            
            function sliderFunctions:SetRange(newMin, newMax)
                min = newMin
                max = newMax
                value = math.clamp(value, min, max)
                self:SetValue(value)
            end
            
            return sliderFunctions
        end
        
        -- Enhanced Dropdown with search functionality
        function tabFunctions:CreateDropdown(name, options, default, callback, optionsConfig)
            optionsConfig = optionsConfig or {}
            local searchable = optionsConfig.searchable or false
            local multiSelect = optionsConfig.multiSelect or false
            
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
            createPadding(dropdownButton, 8, 32, 0, 0)
            
            local dropdownArrow = Instance.new("ImageLabel")
            dropdownArrow.Name = "DropdownArrow"
            dropdownArrow.Size = UDim2.new(0, 16, 0, 16)
            dropdownArrow.Position = UDim2.new(1, -24, 0.5, -8)
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Image = "rbxassetid://3926307971"
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
            
            local searchBox
            if searchable then
                searchBox = Instance.new("TextBox")
                searchBox.Name = "SearchBox"
                searchBox.Size = UDim2.new(1, -16, 0, 28)
                searchBox.Position = UDim2.new(0, 8, 0, 8)
                searchBox.BackgroundColor3 = colors.background
                searchBox.PlaceholderText = "Search..."
                searchBox.Text = ""
                searchBox.TextColor3 = colors.text
                searchBox.Font = Enum.Font.Gotham
                searchBox.TextSize = 12
                searchBox.Parent = dropdownOptions
                
                createRoundCorners(searchBox, 0.05)
                createStroke(searchBox, 1)
                createPadding(searchBox, 8, 8, 0, 0)
            end
            
            local optionsContainer = Instance.new("Frame")
            optionsContainer.Name = "OptionsContainer"
            optionsContainer.Size = UDim2.new(1, 0, 0, 0)
            optionsContainer.Position = UDim2.new(0, 0, 0, searchable and 44 or 8)
            optionsContainer.BackgroundTransparency = 1
            optionsContainer.Parent = dropdownOptions
            
            local optionsListLayout = Instance.new("UIListLayout")
            optionsListLayout.Parent = optionsContainer
            
            local isOpen = false
            local selected = multiSelect and {} or (default or options[1])
            
            local function updateDropdownDisplay()
                if multiSelect then
                    local selectedCount = 0
                    for _, v in pairs(selected) do
                        if v then selectedCount = selectedCount + 1 end
                    end
                    
                    if selectedCount == 0 then
                        dropdownButton.Text = name .. ": None"
                    elseif selectedCount == 1 then
                        for k, v in pairs(selected) do
                            if v then
                                dropdownButton.Text = name .. ": " .. k
                                break
                            end
                        end
                    else
                        dropdownButton.Text = name .. ": " .. selectedCount .. " selected"
                    end
                else
                    dropdownButton.Text = name .. ": " .. selected
                end
            end
            
            local function renderOptions()
                optionsContainer:ClearAllChildren()
                
                local filteredOptions = options
                if searchable and searchBox.Text ~= "" then
                    filteredOptions = {}
                    local searchText = string.lower(searchBox.Text)
                    for _, option in ipairs(options) do
                        if string.find(string.lower(option), searchText, 1, true) then
                            table.insert(filteredOptions, option)
                        end
                    end
                end
                
                for i, option in ipairs(filteredOptions) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option .. "Option"
                    optionButton.Size = UDim2.new(1, -16, 0, 28)
                    optionButton.Position = UDim2.new(0, 8, 0, (i-1)*32)
                    optionButton.BackgroundColor3 = colors.secondary
                    optionButton.Text = option
                    optionButton.TextColor3 = colors.text
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.TextSize = 12
                    optionButton.TextXAlignment = Enum.TextXAlignment.Left
                    optionButton.Parent = optionsContainer
                    
                    createPadding(optionButton, 8, 8, 0, 0)
                    
                    if multiSelect then
                        local checkIcon = Instance.new("ImageLabel")
                        checkIcon.Name = "CheckIcon"
                        checkIcon.Size = UDim2.new(0, 16, 0, 16)
                        checkIcon.Position = UDim2.new(1, -24, 0.5, -8)
                        checkIcon.BackgroundTransparency = 1
                        checkIcon.Image = "rbxassetid://3926307971"
                        checkIcon.ImageColor3 = colors.success
                        checkIcon.ImageRectOffset = Vector2.new(124, 204)
                        checkIcon.ImageRectSize = Vector2.new(16, 16)
                        checkIcon.Visible = selected[option] or false
                        checkIcon.Parent = optionButton
                    else
                        if selected == option then
                            optionButton.BackgroundColor3 = colors.hover
                        end
                    end
                    
                    optionButton.MouseEnter:Connect(function()
                        tweenService:Create(optionButton, tweenInfo, {BackgroundColor3 = colors.hover}):Play()
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        if not multiSelect and selected == option then
                            tweenService:Create(optionButton, tweenInfo, {BackgroundColor3 = colors.hover}):Play()
                        else
                            tweenService:Create(optionButton, tweenInfo, {BackgroundColor3 = colors.secondary}):Play()
                        end
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        if multiSelect then
                            selected[option] = not selected[option]
                            optionButton.CheckIcon.Visible = selected[option]
                        else
                            selected = option
                            toggleDropdown()
                        end
                        
                        updateDropdownDisplay()
                        
                        if callback then
                            if multiSelect then
                                local selectedItems = {}
                                for k, v in pairs(selected) do
                                    if v then table.insert(selectedItems, k) end
                                end
                                callback(selectedItems)
                            else
                                callback(selected)
                            end
                        end
                    end)
                end
                
                optionsContainer.Size = UDim2.new(1, 0, 0, optionsListLayout.AbsoluteContentSize.Y)
                dropdownOptions.Size = UDim2.new(1, 0, 0, optionsListLayout.AbsoluteContentSize.Y + (searchable and 44 or 8))
            end
            
            local function toggleDropdown()
                isOpen = not isOpen
                if isOpen then
                    renderOptions()
                    tweenService:Create(dropdownOptions, tweenInfo, {Size = UDim2.new(1, 0, 0, math.min(optionsListLayout.AbsoluteContentSize.Y + (searchable and 44 or 8), 200))}):Play()
                    tweenService:Create(dropdownArrow, tweenInfo, {Rotation = 0}):Play()
                else
                    tweenService:Create(dropdownOptions, tweenInfo, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    tweenService:Create(dropdownArrow, tweenInfo, {Rotation = 180}):Play()
                end
            end
            
            if searchable then
                searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    if isOpen then
                        renderOptions()
                    end
                end)
            end
            
            dropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            if multiSelect then
                for _, option in ipairs(options) do
                    selected[option] = option == default
                end
                updateDropdownDisplay()
            end
            
            local dropdownFunctions = {}
            
            function dropdownFunctions:SetValue(newValue)
                if multiSelect then
                    for k, _ in pairs(selected) do
                        selected[k] = false
                    end
                    if type(newValue) == "table" then
                        for _, v in ipairs(newValue) do
                            if table.find(options, v) then
                                selected[v] = true
                            end
                        end
                    elseif table.find(options, newValue) then
                        selected[newValue] = true
                    end
                else
                    if table.find(options, newValue) then
                        selected = newValue
                    end
                end
                
                updateDropdownDisplay()
                
                if callback then
                    if multiSelect then
                        local selectedItems = {}
                        for k, v in pairs(selected) do
                            if v then table.insert(selectedItems, k) end
                        end
                        callback(selectedItems)
                    else
                        callback(selected)
                    end
                end
            end
            
            function dropdownFunctions:GetValue()
                if multiSelect then
                    local selectedItems = {}
                    for k, v in pairs(selected) do
                        if v then table.insert(selectedItems, k) end
                    end
                    return selectedItems
                else
                    return selected
                end
            end
            
            function dropdownFunctions:UpdateOptions(newOptions)
                options = newOptions
                if isOpen then
                    renderOptions()
                end
            end
            
            return dropdownFunctions
        end
        
        -- New: Color Picker
        function tabFunctions:CreateColorPicker(name, defaultColor, callback)
            local colorPickerFrame = Instance.new("Frame")
            colorPickerFrame.Name = name .. "ColorPicker"
            colorPickerFrame.Size = UDim2.new(1, 0, 0, 32)
            colorPickerFrame.BackgroundTransparency = 1
            colorPickerFrame.Parent = tabContent
            
            local colorPickerText = Instance.new("TextLabel")
            colorPickerText.Name = "ColorPickerText"
            colorPickerText.Size = UDim2.new(0.7, 0, 1, 0)
            colorPickerText.Position = UDim2.new(0, 0, 0, 0)
            colorPickerText.BackgroundTransparency = 1
            colorPickerText.Text = name
            colorPickerText.TextColor3 = colors.text
            colorPickerText.TextXAlignment = Enum.TextXAlignment.Left
            colorPickerText.Font = Enum.Font.Gotham
            colorPickerText.TextSize = 12
            colorPickerText.Parent = colorPickerFrame
            
            local colorPreview = Instance.new("TextButton")
            colorPreview.Name = "ColorPreview"
            colorPreview.Size = UDim2.new(0, 60, 0, 24)
            colorPreview.Position = UDim2.new(1, -60, 0.5, -12)
            colorPreview.BackgroundColor3 = defaultColor or Color3.new(1, 1, 1)
            colorPreview.Text = ""
            colorPreview.Parent = colorPickerFrame
            
            createRoundCorners(colorPreview, 0.1)
            createStroke(colorPreview, 1)
            
            local colorPickerPopup = Instance.new("Frame")
            colorPickerPopup.Name = "ColorPickerPopup"
            colorPickerPopup.Size = UDim2.new(0, 200, 0, 200)
            colorPickerPopup.Position = UDim2.new(1, 10, 0, 0)
            colorPickerPopup.BackgroundColor3 = colors.secondary
            colorPickerPopup.Visible = false
            colorPickerPopup.ZIndex = 100
            colorPickerPopup.Parent = colorPreview
            
            createRoundCorners(colorPickerPopup, 0.1)
            createStroke(colorPickerPopup, 1)
            
            -- Color spectrum
            local colorSpectrum = Instance.new("ImageLabel")
            colorSpectrum.Name = "ColorSpectrum"
            colorSpectrum.Size = UDim2.new(0, 180, 0, 180)
            colorSpectrum.Position = UDim2.new(0.5, -90, 0, 10)
            colorSpectrum.Image = "rbxassetid://2615689005"
            colorSpectrum.Parent = colorPickerPopup
            
            -- Brightness slider
            local brightnessSlider = Instance.new("Frame")
            brightnessSlider.Name = "BrightnessSlider"
            brightnessSlider.Size = UDim2.new(0, 20, 0, 180)
            brightnessSlider.Position = UDim2.new(1, -25, 0, 10)
            brightnessSlider.BackgroundColor3 = Color3.new(1, 1, 1)
            brightnessSlider.Parent = colorPickerPopup
            
            local brightnessGradient = Instance.new("UIGradient")
            brightnessGradient.Rotation = 90
            brightnessGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            })
            brightnessGradient.Parent = brightnessSlider
            
            createRoundCorners(brightnessSlider, 0.1)
            createStroke(brightnessSlider, 1)
            
            local brightnessHandle = Instance.new("Frame")
            brightnessHandle.Name = "BrightnessHandle"
            brightnessHandle.Size = UDim2.new(1, 4, 0, 8)
            brightnessHandle.Position = UDim2.new(0, -2, 0.5, -4)
            brightnessHandle.BackgroundColor3 = colors.text
            brightnessHandle.Parent = brightnessSlider
            
            createRoundCorners(brightnessHandle, 0.1)
            createStroke(brightnessHandle, 1, colors.stroke)
            
            local currentColor = defaultColor or Color3.new(1, 1, 1)
            local brightness = 1
            local isOpen = false
            
            local function updateColor(hue, sat, val)
                local h, s, v = Color3.toHSV(currentColor)
                currentColor = Color3.fromHSV(hue or h, sat or s, val or v)
                colorPreview.BackgroundColor3 = currentColor
                
                if callback then
                    callback(currentColor)
                end
            end
            
            colorSpectrum.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local x = (input.Position.X - colorSpectrum.AbsolutePosition.X) / colorSpectrum.AbsoluteSize.X
                    local y = (input.Position.Y - colorSpectrum.AbsolutePosition.Y) / colorSpectrum.AbsoluteSize.Y
                    
                    x = math.clamp(x, 0, 1)
                    y = math.clamp(y, 0, 1)
                    
                    updateColor(x, 1 - y, brightness)
                end
            end)
            
            colorSpectrum.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    local x = (input.Position.X - colorSpectrum.AbsolutePosition.X) / colorSpectrum.AbsoluteSize.X
                    local y = (input.Position.Y - colorSpectrum.AbsolutePosition.Y) / colorSpectrum.AbsoluteSize.Y
                    
                    x = math.clamp(x, 0, 1)
                    y = math.clamp(y, 0, 1)
                    
                    updateColor(x, 1 - y, brightness)
                end
            end)
            
            brightnessSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local y = (input.Position.Y - brightnessSlider.AbsolutePosition.Y) / brightnessSlider.AbsoluteSize.Y
                    y = math.clamp(y, 0, 1)
                    
                    brightness = 1 - y
                    tweenService:Create(brightnessHandle, tweenInfo, {Position = UDim2.new(0, -2, y, -4)}):Play()
                    updateColor(nil, nil, brightness)
                end
            end)
            
            brightnessSlider.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    local y = (input.Position.Y - brightnessSlider.AbsolutePosition.Y) / brightnessSlider.AbsoluteSize.Y
                    y = math.clamp(y, 0, 1)
                    
                    brightness = 1 - y
                    tweenService:Create(brightnessHandle, tweenInfo, {Position = UDim2.new(0, -2, y, -4)}):Play()
                    updateColor(nil, nil, brightness)
                end
            end)
            
            colorPreview.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                colorPickerPopup.Visible = isOpen
            end)
            
            local colorPickerFunctions = {}
            
            function colorPickerFunctions:SetValue(newColor)
                currentColor = newColor
                colorPreview.BackgroundColor3 = currentColor
                if callback then
                    callback(currentColor)
                end
            end
            
            function colorPickerFunctions:GetValue()
                return currentColor
            end
            
            return colorPickerFunctions
        end
        
        -- New: Keybind
        function tabFunctions:CreateKeybind(name, defaultKey, callback)
            local keybindFrame = Instance.new("Frame")
            keybindFrame.Name = name .. "Keybind"
            keybindFrame.Size = UDim2.new(1, 0, 0, 32)
            keybindFrame.BackgroundTransparency = 1
            keybindFrame.Parent = tabContent
            
            local keybindText = Instance.new("TextLabel")
            keybindText.Name = "KeybindText"
            keybindText.Size = UDim2.new(0.7, 0, 1, 0)
            keybindText.Position = UDim2.new(0, 0, 0, 0)
            keybindText.BackgroundTransparency = 1
            keybindText.Text = name
            keybindText.TextColor3 = colors.text
            keybindText.TextXAlignment = Enum.TextXAlignment.Left
            keybindText.Font = Enum.Font.Gotham
            keybindText.TextSize = 12
            keybindText.Parent = keybindFrame
            
            local keybindButton = Instance.new("TextButton")
            keybindButton.Name = "KeybindButton"
            keybindButton.Size = UDim2.new(0, 80, 0, 24)
            keybindButton.Position = UDim2.new(1, -80, 0.5, -12)
            keybindButton.BackgroundColor3 = colors.secondary
            keybindButton.Text = defaultKey and defaultKey.Name or "None"
            keybindButton.TextColor3 = colors.text
            keybindButton.Font = Enum.Font.Gotham
            keybindButton.TextSize = 12
            keybindButton.Parent = keybindFrame
            
            createRoundCorners(keybindButton, 0.1)
            createStroke(keybindButton, 1)
            
            local listening = false
            local currentKey = defaultKey
            
            keybindButton.MouseButton1Click:Connect(function()
                listening = true
                keybindButton.Text = "..."
                keybindButton.BackgroundColor3 = colors.accent
            end)
            
            game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                if listening and not gameProcessed then
                    listening = false
                    
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        keybindButton.Text = input.KeyCode.Name
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        currentKey = Enum.UserInputType.MouseButton1
                        keybindButton.Text = "Mouse1"
                    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                        currentKey = Enum.UserInputType.MouseButton2
                        keybindButton.Text = "Mouse2"
                    end
                    
                    keybindButton.BackgroundColor3 = colors.secondary
                    
                    if callback then
                        callback(currentKey)
                    end
                end
            end)
            
            local keybindFunctions = {}
            
            function keybindFunctions:SetValue(newKey)
                currentKey = newKey
                if typeof(newKey) == "EnumItem" then
                    keybindButton.Text = newKey.Name
                else
                    keybindButton.Text = "Mouse" .. tostring(newKey.Value):sub(-1)
                end
            end
            
            function keybindFunctions:GetValue()
                return currentKey
            end
            
            return keybindFunctions
        end
        
        -- New: Label
        function tabFunctions:CreateLabel(text, options)
            options = options or {}
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(1, 0, 0, options.height or 20)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = options.color or colors.text
            label.TextXAlignment = options.align or Enum.TextXAlignment.Left
            label.Font = options.font or Enum.Font.Gotham
            label.TextSize = options.size or 12
            label.TextWrapped = options.wrapped or false
            label.Parent = tabContent
            
            return label
        end
        
        -- New: Textbox
        function tabFunctions:CreateTextbox(name, placeholder, callback, options)
            options = options or {}
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Name = name .. "Textbox"
            textboxFrame.Size = UDim2.new(1, 0, 0, 40)
            textboxFrame.BackgroundTransparency = 1
            textboxFrame.Parent = tabContent
            
            local textboxLabel = Instance.new("TextLabel")
            textboxLabel.Name = "TextboxLabel"
            textboxLabel.Size = UDim2.new(1, 0, 0, 16)
            textboxLabel.Position = UDim2.new(0, 0, 0, 0)
            textboxLabel.BackgroundTransparency = 1
            textboxLabel.Text = name
            textboxLabel.TextColor3 = colors.text
            textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            textboxLabel.Font = Enum.Font.Gotham
            textboxLabel.TextSize = 12
            textboxLabel.Parent = textboxFrame
            
            local textbox = Instance.new("TextBox")
            textbox.Name = "Textbox"
            textbox.Size = UDim2.new(1, 0, 0, 24)
            textbox.Position = UDim2.new(0, 0, 0, 16)
            textbox.BackgroundColor3 = colors.secondary
            textbox.PlaceholderText = placeholder or ""
            textbox.Text = ""
            textbox.TextColor3 = colors.text
            textbox.Font = Enum.Font.Gotham
            textbox.TextSize = 12
            textbox.ClearTextOnFocus = false
            textbox.Parent = textboxFrame
            
            createRoundCorners(textbox, 0.1)
            createStroke(textbox, 1)
            createPadding(textbox, 8, 8, 0, 0)
            
            textbox.FocusLost:Connect(function()
                if callback then
                    callback(textbox.Text)
                end
            end)
            
            local textboxFunctions = {}
            
            function textboxFunctions:SetValue(text)
                textbox.Text = text
            end
            
            function textboxFunctions:GetValue()
                return textbox.Text
            end
            
            return textboxFunctions
        end
        
        return tabFunctions
    end
    
    return tabs
end

return UltraUI
