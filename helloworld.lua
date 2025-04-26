local VapeUI = {}

-- Theme colors
local theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Primary = Color3.fromRGB(40, 40, 50),
    Secondary = Color3.fromRGB(60, 60, 75),
    Accent = Color3.fromRGB(0, 150, 255),
    Text = Color3.fromRGB(220, 220, 220),
    Divider = Color3.fromRGB(50, 50, 60)
}

-- Create main window
function VapeUI:CreateWindow(title)
    local VapeLibrary = {}
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    -- Main screen gui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VapeUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 450, 0, 500)
    MainFrame.Parent = ScreenGui
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = theme.Primary
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = title or "VAPE"
    Title.TextColor3 = theme.Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Divider
    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.BackgroundColor3 = theme.Divider
    Divider.BorderSizePixel = 0
    Divider.Position = UDim2.new(0, 0, 0, 30)
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Parent = MainFrame
    
    -- Tab buttons container
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.BackgroundColor3 = theme.Primary
    TabButtons.BorderSizePixel = 0
    TabButtons.Position = UDim2.new(0, 0, 0, 31)
    TabButtons.Size = UDim2.new(0, 120, 0, 469)
    TabButtons.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = TabButtons
    
    -- Content frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.BackgroundColor3 = theme.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 120, 0, 31)
    ContentFrame.Size = UDim2.new(0, 330, 0, 469)
    ContentFrame.Parent = MainFrame
    
    -- Dragging functionality
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Tab functions
    function VapeLibrary:CreateTab(name)
        local Tab = {}
        
        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.BackgroundColor3 = theme.Secondary
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = name
        TabButton.TextColor3 = theme.Text
        TabButton.TextSize = 12
        TabButton.Parent = TabButtons
        
        -- Tab content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = theme.Accent
        TabContent.Parent = ContentFrame
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Padding = UDim.new(0, 10)
        TabContentLayout.Parent = TabContent
        
        -- Make first tab visible by default
        if #TabButtons:GetChildren() == 2 then -- 1 for UIListLayout
            TabContent.Visible = true
            TabButton.BackgroundColor3 = theme.Accent
        end
        
        -- Tab button click event
        TabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContentFrame:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            
            for _, child in ipairs(TabButtons:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = theme.Secondary
                end
            end
            
            TabContent.Visible = true
            TabButton.BackgroundColor3 = theme.Accent
        end)
        
        -- Section function
        function Tab:CreateSection(name)
            local Section = {}
            
            -- Section frame
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = name
            SectionFrame.BackgroundColor3 = theme.Primary
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, -20, 0, 30)
            SectionFrame.Parent = TabContent
            
            -- Section title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 10, 0, 0)
            SectionTitle.Size = UDim2.new(1, -10, 1, 0)
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.Text = "  "..name
            SectionTitle.TextColor3 = theme.Text
            SectionTitle.TextSize = 12
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            -- Section content
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.BackgroundColor3 = theme.Secondary
            SectionContent.BorderSizePixel = 0
            SectionContent.Position = UDim2.new(0, 0, 0, 30)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Parent = SectionFrame
            
            local SectionContentLayout = Instance.new("UIListLayout")
            SectionContentLayout.Padding = UDim.new(0, 5)
            SectionContentLayout.Parent = SectionContent
            
            -- Update section size when content changes
            SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, -20, 0, 30 + SectionContentLayout.AbsoluteContentSize.Y)
                SectionContent.Size = UDim2.new(1, 0, 0, SectionContentLayout.AbsoluteContentSize.Y)
            end)
            
            -- Button element
            function Section:CreateButton(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = text
                Button.BackgroundColor3 = theme.Background
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, -10, 0, 25)
                Button.Font = Enum.Font.Gotham
                Button.Text = text
                Button.TextColor3 = theme.Text
                Button.TextSize = 12
                Button.Parent = SectionContent
                
                Button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                return Button
            end
            
            -- Toggle element
            function Section:CreateToggle(text, default, callback)
                local Toggle = {}
                local state = default or false
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = text
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, -10, 0, 25)
                ToggleFrame.Parent = SectionContent
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Button"
                ToggleButton.BackgroundColor3 = theme.Background
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Size = UDim2.new(0.8, 0, 1, 0)
                ToggleButton.Font = Enum.Font.Gotham
                ToggleButton.Text = text
                ToggleButton.TextColor3 = theme.Text
                ToggleButton.TextSize = 12
                ToggleButton.TextXAlignment = Enum.TextXAlignment.Left
                ToggleButton.Parent = ToggleFrame
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.BackgroundColor3 = state and theme.Accent or Color3.fromRGB(80, 80, 80)
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Position = UDim2.new(0.85, 0, 0.2, 0)
                ToggleIndicator.Size = UDim2.new(0, 40, 0, 15)
                ToggleIndicator.Parent = ToggleFrame
                
                local ToggleDot = Instance.new("Frame")
                ToggleDot.Name = "Dot"
                ToggleDot.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
                ToggleDot.BorderSizePixel = 0
                ToggleDot.Position = state and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
                ToggleDot.Size = UDim2.new(0, 15, 1, 0)
                ToggleDot.Parent = ToggleIndicator
                
                ToggleButton.MouseButton1Click:Connect(function()
                    state = not state
                    ToggleIndicator.BackgroundColor3 = state and theme.Accent or Color3.fromRGB(80, 80, 80)
                    ToggleDot.Position = state and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
                    
                    if callback then
                        callback(state)
                    end
                end)
                
                function Toggle:Set(value)
                    state = value
                    ToggleIndicator.BackgroundColor3 = state and theme.Accent or Color3.fromRGB(80, 80, 80)
                    ToggleDot.Position = state and UDim2.new(0.5, 0, 0, 0) or UDim2.new(0, 0, 0, 0)
                    
                    if callback then
                        callback(state)
                    end
                end
                
                return Toggle
            end
            
            -- Dropdown element
            function Section:CreateDropdown(text, options, callback)
                local Dropdown = {}
                local isOpen = false
                local selected = options[1] or ""
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = text
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Size = UDim2.new(1, -10, 0, 25)
                DropdownFrame.Parent = SectionContent
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.BackgroundColor3 = theme.Background
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Size = UDim2.new(1, 0, 0, 25)
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Text = text .. ": " .. selected
                DropdownButton.TextColor3 = theme.Text
                DropdownButton.TextSize = 12
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.Parent = DropdownFrame
                
                local DropdownList = Instance.new("Frame")
                DropdownList.Name = "List"
                DropdownList.BackgroundColor3 = theme.Primary
                DropdownList.BorderSizePixel = 0
                DropdownList.Position = UDim2.new(0, 0, 0, 25)
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.Visible = false
                DropdownList.ZIndex = 2
                DropdownList.Parent = DropdownFrame
                
                local DropdownListLayout = Instance.new("UIListLayout")
                DropdownListLayout.Parent = DropdownList
                
                for _, option in ipairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option
                    OptionButton.BackgroundColor3 = theme.Secondary
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, 0, 0, 25)
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = option
                    OptionButton.TextColor3 = theme.Text
                    OptionButton.TextSize = 12
                    OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                    OptionButton.Parent = DropdownList
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selected = option
                        DropdownButton.Text = text .. ": " .. selected
                        isOpen = false
                        DropdownList.Visible = false
                        
                        if callback then
                            callback(selected)
                        end
                    end)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    DropdownList.Visible = isOpen
                    DropdownList.Size = UDim2.new(1, 0, 0, isOpen and (#options * 25) or 0)
                end)
                
                function Dropdown:Set(value)
                    if table.find(options, value) then
                        selected = value
                        DropdownButton.Text = text .. ": " .. selected
                        
                        if callback then
                            callback(selected)
                        end
                    end
                end
                
                return Dropdown
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Close function
    function VapeLibrary:Close()
        ScreenGui:Destroy()
    end
    
    return VapeLibrary
end

return VapeUI
