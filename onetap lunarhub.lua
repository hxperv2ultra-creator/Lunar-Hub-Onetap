local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Settings = {
    ESPEnabled = false,
    AimbotEnabled = false,
    TriggerbotEnabled = false,
    WallCheck = false,
    AimSpeed = 1,
    Speed = 16,
    SpeedEnabled = false,
    AimPart = "Head",
    TeamCheck = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LunarHubGrim"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Transparency = 0.7
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = 150
FOVCircle.Filled = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 680, 0, 440)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 40, 55)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 200, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0, 10, 1, 0)
SidebarFix.Position = UDim2.new(1, -10, 0, 0)
SidebarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
SidebarFix.BorderSizePixel = 0
SidebarFix.Parent = Sidebar

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, -20, 0, 50)
LogoText.Position = UDim2.new(0, 15, 0, 10)
LogoText.BackgroundTransparency = 1
LogoText.Text = "Lunar Hub\nVersion: 1.0"
LogoText.TextColor3 = Color3.fromRGB(220, 220, 235)
LogoText.TextSize = 13
LogoText.Font = Enum.Font.GothamBold
LogoText.TextXAlignment = Enum.TextXAlignment.Left
LogoText.Parent = Sidebar

local NavContainer = Instance.new("ScrollingFrame")
NavContainer.Size = UDim2.new(1, -10, 1, -130)
NavContainer.Position = UDim2.new(0, 5, 0, 70)
NavContainer.BackgroundTransparency = 1
NavContainer.BorderSizePixel = 0
NavContainer.CanvasSize = UDim2.new(0, 0, 0, 100)
NavContainer.ScrollBarThickness = 2
NavContainer.Parent = Sidebar

local NavLayout = Instance.new("UIListLayout")
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 6)
NavLayout.Parent = NavContainer

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -210, 1, -20)
ContentArea.Position = UDim2.new(0, 205, 0, 10)
ContentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

local ContentLayout = Instance.new("UIGridLayout")
ContentLayout.CellSize = UDim2.new(0, 225, 0, 52)
ContentLayout.CellPadding = UDim2.new(0, 10, 0, 10)
ContentLayout.Parent = ContentArea

local ContentScrolling = Instance.new("ScrollingFrame")
ContentScrolling.Size = UDim2.new(1, 0, 1, 0)
ContentScrolling.BackgroundTransparency = 1
ContentScrolling.BorderSizePixel = 0
ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, 350)
ContentScrolling.ScrollBarThickness = 4
ContentScrolling.Parent = ContentArea

ContentLayout.Parent = ContentScrolling

local function createBlockToggle(name, desc, initial, callback)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = ContentScrolling

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -15, 0, 22)
    titleLabel.Position = UDim2.new(0, 12, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.TextColor3 = initial and Color3.fromRGB(160, 120, 255) or Color3.fromRGB(220, 220, 235)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = btn

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -15, 0, 18)
    descLabel.Position = UDim2.new(0, 12, 0, 26)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 150)
    descLabel.TextSize = 11
    descLabel.Font = Enum.Font.GothamMedium
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = btn

    local state = initial
    btn.MouseButton1Click:Connect(function()
        state = not state
        titleLabel.TextColor3 = state and Color3.fromRGB(160, 120, 255) or Color3.fromRGB(220, 220, 235)
        callback(state)
    end)
end

local function createBlockSlider(name, min, max, default, callback)
    local btn = Instance.new("Frame")
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    btn.Parent = ContentScrolling

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -15, 0, 22)
    titleLabel.Position = UDim2.new(0, 12, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name .. ": " .. default
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 235)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = btn

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    sliderBg.Position = UDim2.new(0, 12, 0, 35)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    sliderBg.Parent = btn

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(130, 90, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        titleLabel.Text = name .. ": " .. val
        callback(val)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
end

createBlockToggle("Player & Bot ESP", "Highlights players and bots", false, function(state)
    Settings.ESPEnabled = state
end)

createBlockToggle("Aimbot (RMB)", "Locks onto closest target", false, function(state)
    Settings.AimbotEnabled = state
end)

createBlockToggle("Triggerbot", "Auto-fires when looking at target", false, function(state)
    Settings.TriggerbotEnabled = state
end)

createBlockToggle("Wall Check", "Only targets visible enemies", false, function(state)
    Settings.WallCheck = state
end)

createBlockToggle("FOV Circle", "Shows target radius circle", false, function(state)
    FOVCircle.Visible = state
end)

createBlockToggle("Speed Hack", "Modifies character walkspeed", false, function(state)
    Settings.SpeedEnabled = state
end)

createBlockSlider("WalkSpeed", 16, 150, 16, function(val)
    Settings.Speed = val
end)

createBlockSlider("Aimbot FOV", 50, 400, 150, function(val)
    FOVCircle.Radius = val
end)

createBlockSlider("Aim Speed", 1, 10, 10, function(val)
    Settings.AimSpeed = val / 10
end)

local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(0, 225, 0, 52)
unloadBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
unloadBtn.Text = "Unload Script"
unloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadBtn.TextSize = 13
unloadBtn.Font = Enum.Font.GothamBold
unloadBtn.AutoButtonColor = false
unloadBtn.Parent = ContentScrolling

local unloadCorner = Instance.new("UICorner")
unloadCorner.CornerRadius = UDim.new(0, 8)
unloadCorner.Parent = unloadBtn

unloadBtn.MouseButton1Click:Connect(function()
    FOVCircle:Remove()
    ScreenGui:Destroy()
end)

local function getValidTargets()
    local targets = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
            if hum and root and hum.Health > 0 then
                table.insert(targets, char)
            end
        end
    end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= LocalPlayer.Character then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
            if hum and root and hum.Health > 0 then
                local isPlayer = false
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Character == obj then
                        isPlayer = true
                        break
                    end
                end
                if not isPlayer then
                    table.insert(targets, obj)
                end
            end
        end
    end
    
    return targets
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    
    local targets = getValidTargets()
    for _, char in ipairs(targets) do
        if Settings.ESPEnabled then
            if not char:FindFirstChild("AIWOLFIE_Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "AIWOLFIE_Highlight"
                highlight.Adornee = char
                highlight.FillColor = Color3.fromRGB(160, 120, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.4
                highlight.Parent = char
            end
        else
            local hl = char:FindFirstChild("AIWOLFIE_Highlight")
            if hl then hl:Destroy() end
        end
    end

    if Settings.SpeedEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Settings.Speed
        end
    end
end)

local function isVisible(targetPart)
    if not Settings.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local ignoreList = {LocalPlayer.Character}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then table.insert(ignoreList, p.Character) end
    end
    raycastParams.FilterDescendantsInstances = ignoreList
    
    local result = Workspace:Raycast(origin, direction, raycastParams)
    if result then
        if result.Instance:IsDescendantOf(targetPart.Parent) then
            return true
        end
        return false
    end
    return true
end

local function getClosestTarget()
    local closestPart = nil
    local shortestDist = FOVCircle.Radius
    local mouseLoc = UserInputService:GetMouseLocation()
    local targets = getValidTargets()

    for _, char in ipairs(targets) do
        local targetPart = char:FindFirstChild(Settings.AimPart) or char:FindFirstChild("HumanoidRootPart")
        if targetPart then
            if not Settings.WallCheck or isVisible(targetPart) then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLoc).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestPart = targetPart
                    end
                end
            end
        end
    end
    return closestPart
end

RunService.RenderStepped:Connect(function()
    if Settings.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestTarget()
        if target then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            if Settings.AimSpeed >= 1 then
                Camera.CFrame = targetCFrame
            else
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.AimSpeed)
            end
        end
    end
    
    if Settings.TriggerbotEnabled then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent then
            local hum = target.Parent:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if not Settings.WallCheck or isVisible(target) then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end
        end
    end
end)