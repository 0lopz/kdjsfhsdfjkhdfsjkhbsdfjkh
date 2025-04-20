-- Modern Sleek Dark UI Library
local ModernUI = {}

-- Modern color palette
local colors = {
    dark = Color3.fromRGB(20, 20, 25),
    darker = Color3.fromRGB(15, 15, 18),
    light = Color3.fromRGB(240, 240, 245),
    accent = Color3.fromRGB(0, 180, 255),
    success = Color3.fromRGB(85, 255, 85),
    error = Color3.fromRGB(255, 85, 85),
    element = Color3.fromRGB(30, 30, 38),
    elementHover = Color3.fromRGB(40, 40, 48)
}

-- Animation service
local tweenService = game:GetService("TweenService")

-- Utility functions
local function create(class, props)
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        instance[prop] = value
    end
    return instance
end

local function tween(instance, props, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = tweenService:Create(instance, tweenInfo, props)
    tween:Play()
    return tween
end

-- Rounded corners with adjustable radius
local function roundCorners(instance, radius)
    local corner = create("UICorner", {
        CornerRadius = UDim.new(radius or 0.25, 0),
        Parent = instance
    })
    return corner
end

-- Thin subtle stroke
local function addStroke(instance, color, thickness)
    local stroke = create("UIStroke", {
        Color = color or colors.light,
        Thickness = thickness or 1,
        Transparency = 0.8,
        Parent = instance
    })
    return stroke
end

-- Create the main window
function ModernUI:CreateWindow(title)
    local screenGui = create("ScreenGui", {
        Name = "ModernUI",
        Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false
    })

    -- Main container
    local mainFrame = create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 400, 0, 500),
        Position = UDim2.new(0.5, -200, 0.5, -250),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = colors.dark,
        Parent = screenGui
    })

    roundCorners(mainFrame, 0.08)
    addStroke(mainFrame, colors.accent, 2)

    -- Title bar with gradient
    local titleBar = create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = colors.darker,
        Parent = mainFrame
    })

    roundCorners(titleBar, 0.08)

    local titleGradient = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, colors.darker),
            ColorSequenceKeypoint.new(1, colors.dark)
        }),
        Rotation = 90,
        Parent = titleBar
    })

    local titleText = create("TextLabel", {
        Name = "TitleText",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Modern UI",
        TextColor3 = colors.light,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        Parent = titleBar
    })

    -- Close button with hover effect
    local closeButton = create("ImageButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0.5, -12),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(284, 4),
        ImageRectSize = Vector2.new(24, 24),
        ImageColor3 = colors.light,
        Parent = titleBar
    })

    closeButton.MouseEnter:Connect(function()
        tween(closeButton, {ImageColor3 = colors.error}, 0.15)
    end)

    closeButton.MouseLeave:Connect(function()
        tween(closeButton, {ImageColor3 = colors.light}, 0.15)
    end)

    closeButton.MouseButton1Click:Connect(function()
        tween(mainFrame, {Size = UDim2.new(0, 400, 0, 0)}, 0.2):Completed:Wait()
        screenGui:Destroy()
    end)

    -- Tab system
    local tabButtonsFrame = create("Frame", {
        Name = "TabButtons",
        Size = UDim2.new(1, -20, 0, 32),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    local tabContentFrame = create("Frame", {
        Name = "TabContent",
        Size = UDim2.new(1, -20, 1, -80),
        Position = UDim2.new(0, 10, 0, 80),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = mainFrame
    })

    local tabs = {}
    local currentTab = nil

    -- Draggable window
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
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Tab functions
    local tabFunctions = {}

    function tabFunctions:CreateTab(name, icon)
        local tabButton = create("TextButton", {
            Name = name.."TabButton",
            Size = UDim2.new(0.25, -5, 1, 0),
            Position = UDim2.new(#tabs * 0.25, 0, 0, 0),
            BackgroundColor3 = colors.darker,
            Text = name,
            TextColor3 = colors.light,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Parent = tabButtonsFrame
        })

        roundCorners(tabButton, 0.1)
        addStroke(tabButton, colors.element, 1)

        if icon then
            tabButton.Text = ""
            local iconLabel = create("ImageLabel", {
                Image = "rbxassetid://"..icon,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0.5, -10, 0.5, -10),
                BackgroundTransparency = 1,
                Parent = tabButton
            })
        end

        local tabContent = create("ScrollingFrame", {
            Name = name.."TabContent",
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = colors.element,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = tabContentFrame
        })

        local tabContentLayout = create("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = tabContent
        })

        tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
        end)

        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabContent then
                tween(tabButton, {BackgroundColor3 = colors.elementHover}, 0.15)
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabContent then
                tween(tabButton, {BackgroundColor3 = colors.darker}, 0.15)
            end
        end)

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                tween(currentTab, {Position = UDim2.new(0, 0, 0, 20)}, 0.15)
                currentTab.Visible = false
            end
            
            tabContent.Visible = true
            currentTab = tabContent
            
            -- Highlight active tab
            for _, otherTab in ipairs(tabButtonsFrame:GetChildren()) do
                if otherTab:IsA("TextButton") then
                    tween(otherTab, {
                        BackgroundColor3 = otherTab == tabButton and colors.accent or colors.darker,
                        TextColor3 = otherTab == tabButton and colors.dark or colors.light
                    }, 0.15)
                end
            end
            
            tween(tabContent, {Position = UDim2.new(0, 0, 0, 0)}, 0.15)
        end)

        -- Select first tab by default
        if #tabs == 0 then
            tabButton.BackgroundColor3 = colors.accent
            tabButton.TextColor3 = colors.dark
            tabContent.Visible = true
            currentTab = tabContent
        end

        table.insert(tabs, tabContent)

        -- Section creation
        local sectionFunctions = {}

        function sectionFunctions:CreateSection(title)
            local sectionFrame = create("Frame", {
                Name = title.."Section",
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                Parent = tabContent
            })

            local sectionLayout = create("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = sectionFrame
            })

            local sectionTitle = create("TextLabel", {
                Name = "SectionTitle",
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = string.upper(title),
                TextColor3 = colors.light,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamSemibold,
                TextSize = 12,
                Parent = sectionFrame
            })

            addStroke(sectionTitle, colors.element, 1)

            local sectionContent = create("Frame", {
                Name = "SectionContent",
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                Parent = sectionFrame
            })

            local contentLayout = create("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = sectionContent
            })

            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionContent.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
                sectionFrame.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 26)
            end)

            local elementFunctions = {}

            -- Modern toggle with smooth checkmark animation
            function elementFunctions:CreateToggle(name, default, callback)
                local toggleFrame = create("Frame", {
                    Name = name.."Toggle",
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })

                local toggleLabel = create("TextLabel", {
                    Name = "ToggleLabel",
                    Size = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = colors.light,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = toggleFrame
                })

                local toggleOuter = create("Frame", {
                    Name = "ToggleOuter",
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(0.7, 0, 0.5, -10),
                    AnchorPoint = Vector2.new(0.7, 0.5),
                    BackgroundColor3 = colors.element,
                    Parent = toggleFrame
                })

                roundCorners(toggleOuter, 0.5)
                addStroke(toggleOuter, colors.elementHover, 1)

                local toggleInner = create("Frame", {
                    Name = "ToggleInner",
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 2, 0.5, -8),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = colors.light,
                    Parent = toggleOuter
                })

                roundCorners(toggleInner, 0.5)

                local checkmark = create("ImageLabel", {
                    Name = "Checkmark",
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(0.5, -6, 0.5, -6),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://3926307971",
                    ImageRectOffset = Vector2.new(312, 4),
                    ImageRectSize = Vector2.new(24, 24),
                    ImageColor3 = colors.success,
                    Transparency = 1,
                    Parent = toggleInner
                })

                local state = default or false

                local function updateToggle()
                    if state then
                        tween(toggleOuter, {BackgroundColor3 = colors.success}, 0.2)
                        tween(toggleInner, {
                            Position = UDim2.new(1, -18, 0.5, -8),
                            BackgroundColor3 = colors.light
                        }, 0.2)
                        tween(checkmark, {Transparency = 0}, 0.2)
                    else
                        tween(toggleOuter, {BackgroundColor3 = colors.element}, 0.2)
                        tween(toggleInner, {
                            Position = UDim2.new(0, 2, 0.5, -8),
                            BackgroundColor3 = colors.light
                        }, 0.2)
                        tween(checkmark, {Transparency = 1}, 0.2)
                    end
                end

                updateToggle()

                local toggleButton = create("TextButton", {
                    Name = "ToggleButton",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = toggleFrame
                })

                toggleButton.MouseButton1Click:Connect(function()
                    state = not state
                    updateToggle()
                    if callback then
                        callback(state)
                    end
                end)

                toggleFrame.MouseEnter:Connect(function()
                    tween(toggleLabel, {TextColor3 = colors.accent}, 0.15)
                end)

                toggleFrame.MouseLeave:Connect(function()
                    tween(toggleLabel, {TextColor3 = colors.light}, 0.15)
                end)

                local toggleFunctions = {}

                function toggleFunctions:SetValue(newState)
                    state = newState
                    updateToggle()
                    if callback then
                        callback(state)
                    end
                end

                function toggleFunctions:GetValue()
                    return state
                end

                return toggleFunctions
            end

            -- Modern button with ripple effect
            function elementFunctions:CreateButton(name, callback)
                local button = create("TextButton", {
                    Name = name.."Button",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = colors.element,
                    Text = name,
                    TextColor3 = colors.light,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = sectionContent
                })

                roundCorners(button, 0.1)
                addStroke(button, colors.elementHover, 1)

                local ripple = create("Frame", {
                    Name = "Ripple",
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = colors.light,
                    BackgroundTransparency = 0.8,
                    Parent = button
                })

                roundCorners(ripple, 1)

                button.MouseEnter:Connect(function()
                    tween(button, {BackgroundColor3 = colors.elementHover}, 0.15)
                end)

                button.MouseLeave:Connect(function()
                    tween(button, {BackgroundColor3 = colors.element}, 0.15)
                end)

                button.MouseButton1Click:Connect(function()
                    -- Ripple effect
                    ripple.Size = UDim2.new(0, 0, 0, 0)
                    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                    ripple.BackgroundTransparency = 0.8
                    
                    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                    local pos = button.AbsolutePosition
                    local x = mouse.X - pos.X
                    local y = mouse.Y - pos.Y
                    
                    ripple.Position = UDim2.new(0, x, 0, y)
                    
                    tween(ripple, {
                        Size = UDim2.new(0, button.AbsoluteSize.X * 2, 0, button.AbsoluteSize.X * 2),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, x - button.AbsoluteSize.X, 0, y - button.AbsoluteSize.X)
                    }, 0.5)
                    
                    if callback then
                        callback()
                    end
                end)

                return button
            end

            -- Modern slider with smooth dragging
            function elementFunctions:CreateSlider(name, min, max, default, callback)
                local sliderFrame = create("Frame", {
                    Name = name.."Slider",
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })

                local sliderLabel = create("TextLabel", {
                    Name = "SliderLabel",
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = name..": "..default,
                    TextColor3 = colors.light,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    Parent = sliderFrame
                })

                local sliderBar = create("Frame", {
                    Name = "SliderBar",
                    Size = UDim2.new(1, 0, 0, 4),
                    Position = UDim2.new(0, 0, 0, 30),
                    BackgroundColor3 = colors.element,
                    Parent = sliderFrame
                })

                roundCorners(sliderBar, 0.5)

                local sliderFill = create("Frame", {
                    Name = "SliderFill",
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = colors.accent,
                    Parent = sliderBar
                })

                roundCorners(sliderFill, 0.5)

                local sliderHandle = create("Frame", {
                    Name = "SliderHandle",
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6),
                    BackgroundColor3 = colors.light,
                    Parent = sliderBar
                })

                roundCorners(sliderHandle, 1)
                addStroke(sliderHandle, colors.accent, 1)

                local value = default or min
                local dragging = false

                local function updateSlider(input)
                    local xScale = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                    xScale = math.clamp(xScale, 0, 1)
                    
                    value = math.floor(min + (max - min) * xScale)
                    sliderLabel.Text = name..": "..value
                    sliderFill.Size = UDim2.new(xScale, 0, 1, 0)
                    sliderHandle.Position = UDim2.new(xScale, -6, 0.5, -6)
                    
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
                    sliderLabel.Text = name..": "..value
                    tween(sliderFill, {Size = UDim2.new(xScale, 0, 1, 0)}, 0.2)
                    tween(sliderHandle, {Position = UDim2.new(xScale, -6, 0.5, -6)}, 0.2)
                    
                    if callback then
                        callback(value)
                    end
                end

                function sliderFunctions:GetValue()
                    return value
                end

                return sliderFunctions
            end

            return elementFunctions
        end

        return sectionFunctions
    end

    return tabFunctions
end

return ModernUI
