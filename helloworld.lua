local JIGUID = {}

-- VAPE V4 inspired theme
local theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Primary = Color3.fromRGB(25, 25, 30),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(220, 220, 220),
    Divider = Color3.fromRGB(45, 45, 55),
    Error = Color3.fromRGB(255, 50, 50)
}

-- Create main window with VAPE V4 styling
function JIGUID:CreateWindow(title)
    local JIGUIDLibrary = {}
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    -- Main screen gui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "JIGUID"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main frame with V4 styling
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Parent = ScreenGui
    
    -- Title bar with gradient like V4
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = theme.Primary
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = MainFrame
    
    -- Gradient effect
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    Gradient.Rotation = 90
    Gradient.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title or "JIGUID"
    Title.TextColor3 = theme.Accent
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Close button (V4 style)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = theme.Text
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Divider with subtle glow
    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.BackgroundColor3 = theme.Accent
    Divider.BorderSizePixel = 0
    Divider.Position = UDim2.new(0, 0, 0, 30)
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Parent = MainFrame
    
    -- Tab buttons container (left side)
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.BackgroundColor3 = theme.Primary
    TabButtons.BorderSizePixel = 0
    TabButtons.Position = UDim2.new(0, 0, 0, 31)
    TabButtons.Size = UDim2.new(0, 120, 0, 369)
    TabButtons.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 1)
    UIListLayout.Parent = TabButtons
    
    -- Content frame (right side)
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.BackgroundColor3 = theme.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 120, 0, 31)
    ContentFrame.Size = UDim2.new(0, 380, 0, 369)
    ContentFrame.Parent = MainFrame
    
    -- Error bar (bottom section like your image)
    local ErrorBar = Instance.new("Frame")
    ErrorBar.Name = "ErrorBar"
    ErrorBar.BackgroundColor3 = theme.Primary
    ErrorBar.BorderSizePixel = 0
    ErrorBar.Position = UDim2.new(0, 0, 0, 400)
    ErrorBar.Size = UDim2.new(1, 0, 0, 30)
    ErrorBar.Visible = false -- Hidden by default
    ErrorBar.Parent = MainFrame
    
    local ErrorLabel = Instance.new("TextLabel")
    ErrorLabel.Name = "ErrorLabel"
    ErrorLabel.BackgroundTransparency = 1
    ErrorLabel.Size = UDim2.new(1, -10, 1, 0)
    ErrorLabel.Position = UDim2.new(0, 10, 0, 0)
    ErrorLabel.Font = Enum.Font.Gotham
    ErrorLabel.Text = ""
    ErrorLabel.TextColor3 = theme.Error
    ErrorLabel.TextSize = 12
    ErrorLabel.TextXAlignment = Enum.TextXAlignment.Left
    ErrorLabel.Parent = ErrorBar
    
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
    function JIGUIDLibrary:CreateTab(name)
        local Tab = {}
        
        -- Tab button with V4 style
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.BackgroundColor3 = theme.Secondary
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Font = Enum.Font.GothamSemibold
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
        
        -- Section function with table view like your image
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
            SectionTitle.TextColor3 = theme.Accent
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
            
            -- Create table view like your Errorbar section
            function Section:CreateTable(headers, rows)
                local TableFrame = Instance.new("Frame")
                TableFrame.Name = "TableFrame"
                TableFrame.BackgroundColor3 = theme.Background
                TableFrame.BorderSizePixel = 0
                TableFrame.Size = UDim2.new(1, 0, 0, 30 + (#rows * 25))
                TableFrame.Parent = SectionContent
                
                -- Header row
                local HeaderFrame = Instance.new("Frame")
                HeaderFrame.Name = "HeaderFrame"
                HeaderFrame.BackgroundColor3 = theme.Primary
                HeaderFrame.BorderSizePixel = 0
                HeaderFrame.Size = UDim2.new(1, 0, 0, 25)
                HeaderFrame.Parent = TableFrame
                
                -- Create columns based on headers
                for i, header in ipairs(headers) do
                    local columnWidth = 1 / #headers
                    local HeaderLabel = Instance.new("TextLabel")
                    HeaderLabel.Name = header
                    HeaderLabel.BackgroundTransparency = 1
                    HeaderLabel.Position = UDim2.new((i-1) * columnWidth, 5, 0, 0)
                    HeaderLabel.Size = UDim2.new(columnWidth, -10, 1, 0)
                    HeaderLabel.Font = Enum.Font.GothamSemibold
                    HeaderLabel.Text = header
                    HeaderLabel.TextColor3 = theme.Accent
                    HeaderLabel.TextSize = 12
                    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
                    HeaderLabel.Parent = HeaderFrame
                    
                    -- Add divider between columns
                    if i < #headers then
                        local Divider = Instance.new("Frame")
                        Divider.Name = "Divider"
                        Divider.BackgroundColor3 = theme.Divider
                        Divider.BorderSizePixel = 0
                        Divider.Position = UDim2.new(i * columnWidth, 0, 0, 0)
                        Divider.Size = UDim2.new(0, 1, 1, 0)
                        Divider.Parent = HeaderFrame
                    end
                end
                
                -- Create data rows
                for rowIndex, rowData in ipairs(rows) do
                    local RowFrame = Instance.new("Frame")
                    RowFrame.Name = "Row_"..rowIndex
                    RowFrame.BackgroundColor3 = rowIndex % 2 == 0 and theme.Secondary or Color3.fromRGB(40, 40, 50)
                    RowFrame.BorderSizePixel = 0
                    RowFrame.Position = UDim2.new(0, 0, 0, 25 + ((rowIndex-1) * 25))
                    RowFrame.Size = UDim2.new(1, 0, 0, 25)
                    RowFrame.Parent = TableFrame
                    
                    -- Create cells for each row
                    for colIndex, cellValue in ipairs(rowData) do
                        local columnWidth = 1 / #headers
                        local CellLabel = Instance.new("TextLabel")
                        CellLabel.Name = "Cell_"..colIndex
                        CellLabel.BackgroundTransparency = 1
                        CellLabel.Position = UDim2.new((colIndex-1) * columnWidth, 5, 0, 0)
                        CellLabel.Size = UDim2.new(columnWidth, -10, 1, 0)
                        CellLabel.Font = Enum.Font.Gotham
                        CellLabel.Text = tostring(cellValue)
                        CellLabel.TextColor3 = theme.Text
                        CellLabel.TextSize = 12
                        CellLabel.TextXAlignment = Enum.TextXAlignment.Left
                        CellLabel.Parent = RowFrame
                    end
                end
                
                return TableFrame
            end
            
            -- Button element with V4 style
            function Section:CreateButton(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = text
                Button.BackgroundColor3 = theme.Background
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, -10, 0, 25)
                Button.Font = Enum.Font.GothamSemibold
                Button.Text = text
                Button.TextColor3 = theme.Text
                Button.TextSize = 12
                Button.Parent = SectionContent
                
                -- Hover effects
                Button.MouseEnter:Connect(function()
                    game:GetService("TweenService"):Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    game:GetService("TweenService"):Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = theme.Background}):Play()
                end)
                
                Button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                return Button
            end
            
            return Section
        end
        
        -- Show error message in the bottom bar
        function JIGUIDLibrary:ShowError(message)
            ErrorLabel.Text = message
            ErrorBar.Visible = true
            wait(3)
            ErrorBar.Visible = false
        end
        
        return Tab
    end
    
    -- Close function
    function JIGUIDLibrary:Close()
        ScreenGui:Destroy()
    end
    
    return JIGUIDLibrary
end

return JIGUID
