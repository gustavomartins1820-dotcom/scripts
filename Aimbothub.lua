local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local PanelData = {
    Open = false,
    CurrentTab = "Aimbot",
    Aimbot = {
        Enabled = false,
        FOV = 200,
        TargetPart = "Cabeça",
        Smoothness = 0.3
    },
    ESP = {
        Enabled = false,
        TeamCheck = false,
        ShowName = true,
        ShowHealth = true,
        ShowTracers = true,
        ShowBox = true,
        ShowDistance = true
    },
    Performance = {
        BoostFPS = false,
        ShowFPS = true
    }
}

local function CreateModernUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernPanel"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    local blur = Instance.new("BlurEffect")
    blur.Name = "PanelBlur"
    blur.Size = 0
    blur.Parent = game:GetService("Lighting")
    
    local floatingButton = Instance.new("ImageButton")
    floatingButton.Name = "FloatingButton"
    floatingButton.Size = UDim2.new(0, 60, 0, 60)
    floatingButton.Position = UDim2.new(0, 20, 0, 120)
    floatingButton.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
    floatingButton.BackgroundTransparency = 0.1
    floatingButton.BorderSizePixel = 0
    floatingButton.Image = "rbxassetid://3926305904"
    floatingButton.ImageColor3 = Color3.fromRGB(0, 180, 255)
    floatingButton.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = floatingButton
    
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 400, 0, 550)
    mainPanel.Position = UDim2.new(0.5, -200, 0.5, -275)
    mainPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    mainPanel.BackgroundTransparency = 1
    mainPanel.Visible = false
    mainPanel.Parent = screenGui
    
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    background.BackgroundTransparency = 0.9
    background.Parent = mainPanel
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 12)
    bgCorner.Parent = background
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "⚡ PAINEL ADMIN ⚡"
    title.TextColor3 = Color3.fromRGB(0, 180, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = background
    
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(0.9, 0, 0, 2)
    separator.Position = UDim2.new(0.05, 0, 0, 58)
    separator.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
    separator.BackgroundTransparency = 0.5
    separator.Parent = background
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 45)
    tabContainer.Position = UDim2.new(0, 0, 0, 63)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = background
    
    local tabs = {
        {Name = "Aimbot", Icon = "🎯"},
        {Name = "ESP", Icon = "👁"},
        {Name = "Performance", Icon = "⚡"}
    }
    
    local tabButtons = {}
    local tabContents = {}
    
    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Name = tab.Name.."Tab"
        btn.Size = UDim2.new(0.33, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.33, 0, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = tab.Icon.." "..tab.Name
        btn.TextColor3 = Color3.fromRGB(180, 180, 200)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = tabContainer
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        tabButtons[tab.Name] = btn
        
        btn.MouseButton1Click:Connect(function()
            for name, button in pairs(tabButtons) do
                button.TextColor3 = Color3.fromRGB(180, 180, 200)
            end
            btn.TextColor3 = Color3.fromRGB(0, 180, 255)
            PanelData.CurrentTab = tab.Name
            for name, content in pairs(tabContents) do
                content.Visible = (name == tab.Name)
            end
        end)
    end
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -20, 1, -130)
    contentContainer.Position = UDim2.new(0, 10, 0, 112)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = background
    
    local function CreateToggle(parent, text, yPos, varName)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 220)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.Parent = frame
        
        local toggle = Instance.new("ImageButton")
        toggle.Size = UDim2.new(0, 55, 0, 28)
        toggle.Position = UDim2.new(0.85, 0, 0.5, -14)
        toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        toggle.BackgroundTransparency = 0.3
        toggle.Parent = frame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggle
        
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 22, 0, 22)
        indicator.Position = UDim2.new(0, 3, 0.5, -11)
        indicator.BackgroundColor3 = Color3.fromRGB(150, 150, 170)
        indicator.Parent = toggle
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = indicator
        
        local currentState = false
        
        toggle.MouseButton1Click:Connect(function()
            currentState = not currentState
            if currentState then
                indicator.Position = UDim2.new(0, 30, 0.5, -11)
                indicator.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
                toggle.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            else
                indicator.Position = UDim2.new(0, 3, 0.5, -11)
                indicator.BackgroundColor3 = Color3.fromRGB(150, 150, 170)
                toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            end
            if varName then
                local parts = {}
                for part in string.gmatch(varName, "[^%.]+") do
                    table.insert(parts, part)
                end
                local data = PanelData
                for i = 1, #parts - 1 do
                    data = data[parts[i]]
                end
                data[parts[#parts]] = currentState
            end
        end)
        
        return toggle, currentState
    end
    
    local function CreateSlider(parent, text, yPos, min, max, default, varName)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 50)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.4, 0)
        label.BackgroundTransparency = 1
        label.Text = text..": "..tostring(default)
        label.TextColor3 = Color3.fromRGB(200, 200, 220)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.Parent = frame
        
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(0.85, 0, 0, 8)
        slider.Position = UDim2.new(0, 0, 0.7, 0)
        slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        slider.Parent = frame
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(1, 0)
        sliderCorner.Parent = slider
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        fill.Parent = slider
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill
        
        local currentValue = default
        
        slider.MouseButton1Down:Connect(function()
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local touchPos = UserInputService:GetMouseLocation()
                local pos = touchPos.X - slider.AbsolutePosition.X
                local percent = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
                currentValue = min + (max - min) * percent
                currentValue = math.round(currentValue)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                label.Text = text..": "..tostring(currentValue)
                if varName then
                    local parts = {}
                    for part in string.gmatch(varName, "[^%.]+") do
                        table.insert(parts, part)
                    end
                    local data = PanelData
                    for i = 1, #parts - 1 do
                        data = data[parts[i]]
                    end
                    data[parts[#parts]] = currentValue
                end
            end)
            local releaseConnection
            releaseConnection = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    connection:Disconnect()
                    releaseConnection:Disconnect()
                end
            end)
        end)
        
        return slider, currentValue
    end
    
    local function CreateDropdown(parent, text, yPos, options, varName)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 220)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.Parent = frame
        
        local dropdown = Instance.new("TextButton")
        dropdown.Size = UDim2.new(0.5, 0, 1, 0)
        dropdown.Position = UDim2.new(0.5, 0, 0, 0)
        dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        dropdown.Text = options[1]
        dropdown.TextColor3 = Color3.fromRGB(200, 200, 220)
        dropdown.TextScaled = true
        dropdown.Font = Enum.Font.Gotham
        dropdown.Parent = frame
        
        local dropdownCorner = Instance.new("UICorner")
        dropdownCorner.CornerRadius = UDim.new(0, 6)
        dropdownCorner.Parent = dropdown
        
        local selected = options[1]
        
        dropdown.MouseButton1Click:Connect(function()
            local menu = Instance.new("Frame")
            menu.Size = UDim2.new(0.5, 0, 0, #options * 35)
            menu.Position = UDim2.new(0.5, 0, 0, 40)
            menu.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            menu.Parent = frame
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 6)
            menuCorner.Parent = menu
            
            for i, option in ipairs(options) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 35)
                btn.Position = UDim2.new(0, 0, 0, (i-1) * 35)
                btn.BackgroundTransparency = 1
                btn.Text = option
                btn.TextColor3 = Color3.fromRGB(200, 200, 220)
                btn.TextScaled = true
                btn.Font = Enum.Font.Gotham
                btn.Parent = menu
                
                btn.MouseButton1Click:Connect(function()
                    selected = option
                    dropdown.Text = option
                    menu:Destroy()
                    if varName then
                        local parts = {}
                        for part in string.gmatch(varName, "[^%.]+") do
                            table.insert(parts, part)
                        end
                        local data = PanelData
                        for i = 1, #parts - 1 do
                            data = data[parts[i]]
                        end
                        data[parts[#parts]] = option
                    end
                end)
            end
        end)
        
        return dropdown, selected
    end
    
    local aimbotContent = Instance.new("ScrollingFrame")
    aimbotContent.Name = "AimbotContent"
    aimbotContent.Size = UDim2.new(1, 0, 1, 0)
    aimbotContent.BackgroundTransparency = 1
    aimbotContent.CanvasSize = UDim2.new(0, 0, 0, 280)
    aimbotContent.ScrollBarThickness = 4
    aimbotContent.Parent = contentContainer
    tabContents["Aimbot"] = aimbotContent
    
    CreateToggle(aimbotContent, "Ativar Aimbot", 5, "Aimbot.Enabled")
    CreateSlider(aimbotContent, "FOV", 50, 10, 500, 200, "Aimbot.FOV")
    CreateDropdown(aimbotContent, "Alvo", 105, {"Cabeça", "Tronco", "Braço", "Perna"}, "Aimbot.TargetPart")
    CreateSlider(aimbotContent, "Suavidade", 150, 1, 100, 30, "Aimbot.Smoothness")
    
    local espContent = Instance.new("ScrollingFrame")
    espContent.Name = "ESPContent"
    espContent.Size = UDim2.new(1, 0, 1, 0)
    espContent.BackgroundTransparency = 1
    espContent.CanvasSize = UDim2.new(0, 0, 0, 350)
    espContent.ScrollBarThickness = 4
    espContent.Visible = false
    espContent.Parent = contentContainer
    tabContents["ESP"] = espContent
    
    CreateToggle(espContent, "Ativar ESP", 5, "ESP.Enabled")
    CreateToggle(espContent, "Team Check", 50, "ESP.TeamCheck")
    CreateToggle(espContent, "ESP Nome", 95, "ESP.ShowName")
    CreateToggle(espContent, "ESP Vida", 140, "ESP.ShowHealth")
    CreateToggle(espContent, "ESP Linhas", 185, "ESP.ShowTracers")
    CreateToggle(espContent, "ESP Caixa", 230, "ESP.ShowBox")
    CreateToggle(espContent, "ESP Distância", 275, "ESP.ShowDistance")
    
    local perfContent = Instance.new("ScrollingFrame")
    perfContent.Name = "PerfContent"
    perfContent.Size = UDim2.new(1, 0, 1, 0)
    perfContent.BackgroundTransparency = 1
    perfContent.CanvasSize = UDim2.new(0, 0, 0, 200)
    perfContent.ScrollBarThickness = 4
    perfContent.Visible = false
    perfContent.Parent = contentContainer
    tabContents["Performance"] = perfContent
    
    CreateToggle(perfContent, "Boost FPS", 5, "Performance.BoostFPS")
    CreateToggle(perfContent, "Mostrar FPS", 50, "Performance.ShowFPS")
    
    local function TogglePanel()
        PanelData.Open = not PanelData.Open
        mainPanel.Visible = PanelData.Open
        
        if PanelData.Open then
            blur.Size = 12
            local tween = TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1})
            tween:Play()
            
            for name, button in pairs(tabButtons) do
                if name == PanelData.CurrentTab then
                    button.TextColor3 = Color3.fromRGB(0, 180, 255)
                end
            end
            for name, content in pairs(tabContents) do
                content.Visible = (name == PanelData.CurrentTab)
            end
        else
            blur.Size = 0
            local tween = TweenService:Create(mainPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
            tween:Play()
            wait(0.2)
            mainPanel.Visible = false
        end
    end
    
    floatingButton.MouseButton1Click:Connect(TogglePanel)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.X then
            TogglePanel()
        end
    end)
    
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FPSLabel"
    fpsLabel.Size = UDim2.new(0, 70, 0, 35)
    fpsLabel.Position = UDim2.new(0, 10, 0, 10)
    fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fpsLabel.BackgroundTransparency = 0.5
    fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    fpsLabel.TextScaled = true
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.Visible = false
    fpsLabel.Parent = screenGui
    
    local fpsCorner = Instance.new("UICorner")
    fpsCorner.CornerRadius = UDim.new(0, 6)
    fpsCorner.Parent = fpsLabel
    
    local frameCount = 0
    local lastTime = tick()
    
    RunService.Heartbeat:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= 0.5 then
            local fps = math.round(frameCount / (currentTime - lastTime))
            fpsLabel.Text = "FPS: "..tostring(fps)
            frameCount = 0
            lastTime = currentTime
        end
        
        fpsLabel.Visible = PanelData.Performance.ShowFPS
        
        if PanelData.Performance.BoostFPS then
            settings().Rendering.QualityLevel = 1
        else
            settings().Rendering.QualityLevel = 3
        end
    end)
    
    local fovCircle = Instance.new("Frame")
    fovCircle.Name = "FOVCircle"
    fovCircle.Size = UDim2.new(0, PanelData.Aimbot.FOV, 0, PanelData.Aimbot.FOV)
    fovCircle.Position = UDim2.new(0.5, -PanelData.Aimbot.FOV/2, 0.5, -PanelData.Aimbot.FOV/2)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Visible = false
    fovCircle.Parent = screenGui
    
    local circleImage = Instance.new("ImageLabel")
    circleImage.Size = UDim2.new(1, 0, 1, 0)
    circleImage.BackgroundTransparency = 1
    circleImage.Image = "rbxassetid://2104791415"
    circleImage.ImageColor3 = Color3.fromRGB(0, 180, 255)
    circleImage.ImageTransparency = 0.7
    circleImage.Parent = fovCircle
    
    local function UpdateFOV()
        local fovSize = PanelData.Aimbot.FOV
        fovCircle.Size = UDim2.new(0, fovSize, 0, fovSize)
        fovCircle.Position = UDim2.new(0.5, -fovSize/2, 0.5, -fovSize/2)
        fovCircle.Visible = PanelData.Aimbot.Enabled
    end
    
    RunService.Heartbeat:Connect(UpdateFOV)
    
    local camera = workspace.CurrentCamera
    
    RunService.Heartbeat:Connect(function()
        if PanelData.Aimbot.Enabled then
            local target = nil
            local closest = PanelData.Aimbot.FOV
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local character = player.Character
                    local part = character:FindFirstChild(PanelData.Aimbot.TargetPart)
                    if not part then
                        part = character:FindFirstChild("Head")
             
